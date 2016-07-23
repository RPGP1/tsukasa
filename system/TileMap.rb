#! ruby -E utf-8

###############################################################################
#TSUKASA for DXRuby ver1.2.1(2016/5/2)
#メッセージ指向ゲーム記述言語「司エンジン（Tsukasa Engine）」 for DXRuby
#
#Copyright (c) <2013-2016> <tsukasa TSUCHIYA>
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

module Tsukasa

class TileMap < DrawableLayout

  attr_accessor :map_array
  attr_accessor :image_array
  attr_accessor :map_x
  attr_accessor :map_y
  attr_accessor :size_x
  attr_accessor :size_y

  def initialize(options, yield_block_stack, root_control, parent_control, &block)
    options[:width] = options[:width] || 32
    options[:height] = options[:height] || 32

    @map_array = options[:map_array] || []
    @image_array = options[:image_array] || []
    @map_x = options[:map_x] || 0
    @map_y = options[:map_y] || 0
    @size_x = options[:size_x] || 1
    @size_y = options[:size_y] || 1

    super
  end

  def dispose()
    @image_array.each do |image|
      image.dispose
    end
    super
  end

  def render(offset_x, offset_y, target)
    #描画オブジェクトを持ち、かつ可視でなければ戻る
    return super unless @image_array

    @entity.draw_tile(0, 0, 
                      @map_array, @image_array, 
                      @map_x, @map_y, 
                      @size_x, @size_y, 
                      @z)

    return super
  end

  def _SET_TILE_(argument, options, yield_block_stack)
    if argument
      @image_array[argument] = DXRuby::Image.load(options[:path])
    else
      @image_array.push(DXRuby::Image.load(options[:path]))
    end
  end

  def _SET_TILE_GROUP_(argument, options, yield_block_stack)
    image_array = DXRuby::Image.load_tiles( options[:path], 
                                    options[:x_count] || 1, 
                                    options[:y_count] || 1, 
                                    options[:share_switch] || false)
    
    if argument
      counter = argument
      image_array.each do |image|
        @image_array[counter] = image
        counter += 1
      end
    else
      @image_array += image_array
    end
  end

  def _MAP_STATUS_(argument, options, yield_block_stack, &block)
    if argument
      @map_array[options[:x] || 0][options[:y] || 0] = argument
    else
      #ブロックが付与されているならそれを実行する
      parse_block(@map_array[options[:x] || 0][options[:y] || 0], nil,
                  yield_block_stack, &block)
    end
  end

end

end