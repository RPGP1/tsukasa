#! ruby -E utf-8

###############################################################################
#TSUKASA for DXRuby ver2.2(2017/2/14)
#メッセージ指向ゲーム記述言語「司エンジン（Tsukasa Engine）」 for DXRuby
#
#Copyright (c) <2013-2017> <tsukasa TSUCHIYA>
#
#This software is provided 'as-is', without any express or implied
#warranty. In no event will the authors be held liable for any damages
#arising from the use of this software.
#
#Permission is granted to anyone to use this software for any purpose,
#including commercial applications, and to alter it and redistribute it
#freely, subject to the following restrictions:
#
#   1. The origin of this software must not be misrepresented; you must not
#   claim that you wrote the original software. If you use this software
#   in a product, an acknowledgment in the product documentation would be
#   appreciated but is not required.
#
#   2. Altered source versions must be plainly marked as such, and must not be
#   misrepresented as being the original software.
#
#   3. This notice may not be removed or altered from any source
#   distribution.
#
#[The zlib/libpng License http://opensource.org/licenses/Zlib]
###############################################################################

require_relative './Drawable.rb'

module Tsukasa

#画像コントロール
class Image < Control
  include Drawable
  #DXRuby::Imageのキャッシュマネージャー
  @@ImageCache = CacheManager.new do |id|
    DXRuby::Image.load(id)
  end
  
  def self.cache()
    return @@ImageCache
  end

  attr_reader :path
  def path=(path)
    #元Imageを解放
    @@ImageCache.dispose(@path) if @path
    #新Imageを取得
    @path = path
    @entity = @@ImageCache.load(@path)
  end

  def dispose()
    @@ImageCache.dispose(@path) if @path
    super
  end

  def initialize( system, 
                  _IMAGE_API_: DXRuby::Image,
                  _FONT_API_: DXRuby::Font,
                  _RENDERTARGET_API_: DXRuby::RenderTarget,
                  width: 1, 
                  height: 1, 
                  path: nil, 
                  color: [0,0,0,0], 
                  **options, 
                  &block)
    @_IMAGE_API_ = _IMAGE_API_
    @_FONT_API_ = _FONT_API_
    @_RENDERTARGET_API_ = _RENDERTARGET_API_
    @path = nil
    super

    if path
      self.path = path
    else
      @entity = @_IMAGE_API_.new(width, height, color)
    end
  end

  #Image上に直線を引く
  def _LINE_(x1:, y1:, x2:, y2:, color:)
    @entity.line( 
      x1, y1, x2, y2, color)
  end

  #Image上に矩形を描く
  def _BOX_(x1:, y1:, x2:, y2:, color:, fill: false)
    if fill
      @entity.box_fill(x1, y1, x2, y2, color)
    else
      @entity.box(x1, y1, x2, y2, color)
    end
  end

  #Image上に円を描く
  def _CIRCLE_(x:, y:, r:, color:, fill: false)
    if fill
      @entity.circle_fill(x, y, r, color)
    else
      @entity.circle(x, y, r, color)
    end
  end

  #Image上に三角形を描く
  def _TRIANGLE_(x1:, y1:, x2:, y2:,  x3:, y3:, color:, fill: false)
    if fill
      @entity.triangle_fill(x1, y1, x2, y2, x3, y3, color)
    else
      @entity.triangle(x1, y1, x2, y2, x3, y3, color)
    end
  end

  #Image上に文字を描く
  def _TEXT_( _ARGUMENT_: "", weight: 4, option: {}, color: [0, 0, 0, 0],
              x: 0, y: 0, size: 24, font_name: "", italic: false)
    if color
      option[:color] = color
    end

    @entity.draw_font_ex(
      x, y,
      _ARGUMENT_,
      @_FONT_API_.new(size, font_name,{weight: weight * 100, italic: italic}),
      option)
  end

  #Imageを指定色で塗りつぶす
  def _FILL_(_ARGUMENT_:)
    @entity.fill(_ARGUMENT_)
  end

  #Imageを[0,0,0,0]で塗りつぶす
  def _CLEAR_(**)
    @entity.clear
  end

  #Imageの指定座標への色の取得／設定
  def _PIXEL_(x:, y:, color: nil)
    if color
      @entity[x, y] = color
    end
    if command_block?
      #ブロックが付与されているならそれを実行する
      unshift_command_block({color: @entity[x, y]})
    end
  end

  #Imageを指定座標の色を比較し、同値ならブロックを実行する
  def _COMPARE_(x:, y:, color:)
    if @entity.compare(x, y, color)
      #ブロックが付与されているならそれを実行する
      unshift_command_block()
    end
  end

  #画像を保存する
  def _SAVE_IMAGE_(_ARGUMENT_:, format: FORMAT_PNG)
    @entity.save(_ARGUMENT_, format)
  end

  #指定したツリーを描画する
  def _DRAW_(_ARGUMENT_: , x: 0, y: 0, scale: nil)
    #中間バッファを生成
    rt = @_RENDERTARGET_API_.new(@entity.width, @entity.height)

    #描画対象コントロールの検索
    control = find_control(_ARGUMENT_)

    #コントロールの探査に失敗
    unless control
      warn "コントロール\"#{_ARGUMENT_}\"が存在しません"
      return
    end

    #中間バッファに描画（指定したコントロール自身は描画されないので注意）
    control.render(0,0,rt)

    #拡大率が設定されている場合
    if scale
      #第２中間バッファを生成
      rt2 = @_RENDERTARGET_API_.new( scale * @entity.width, 
                                      scale * @entity.height)
      #拡大率を反映して第２中間バッファに描画
      rt2.draw_ex(-1 * scale**2 * @entity.width,
                  -1 * scale**2 * @entity.height,
                  rt,
                  {:scale_x => scale,
                   :scale_y => scale,})
      #自身に描画
      @entity.draw(x, y, rt2.to_image)
    else
      #自身に描画
      @entity.draw(x, y, rt.to_image)
    end
  end
end

end