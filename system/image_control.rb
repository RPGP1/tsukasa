#! ruby -E utf-8

require 'dxruby'

###############################################################################
#TSUKASA for DXRuby ver1.2(2016/3/1)
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

#画像コントロール
class ImageControl < DrawableControl
  
  attr_reader :file_path
  def file_path=(file_path)
    @file_path = file_path
    #画像ファイルをキャッシュから読み込んで初期化する
    @entity = @@image_cache[file_path]
  end

  def initialize(options, yield_block_stack, root_control, &block)
    if options[:file_path]
      @file_path = options[:file_path]
      options[:entity] = @@image_cache[options[:file_path]]
    end
    super
  end

  #画像を保存する
  def _SAVE_IMAGE_(argument, options, yield_block_stack)
    @entity.save(argument,options[:format] || FORMAT_PNG)
  end
end
