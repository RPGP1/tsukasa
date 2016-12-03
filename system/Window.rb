#! ruby -E utf-8
# coding: utf-8

#$VERBOSE = true

###############################################################################
#TSUKASA for DXRuby ver2.0(2016/8/28)
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

class Window < Layout
  def mouse_x()
    return DXRuby::Input.mouse_x
  end
  def mouse_x=(arg)
    DXRuby::Input.set_mouse_pos(arg, DXRuby::Input.mouse_y)
  end

  def mouse_y()
    return DXRuby::Input.mouse_y
  end
  def mouse_y=(arg)
    DXRuby::Input.set_mouse_pos(DXRuby::Input.mouse_x, arg)
  end

  def initialize( options = {}, 
                  yield_stack = nil, 
                  root_control = nil, 
                  parent_control = nil)
    #アプリ終了フラグ
    @close = false

    super
  end

  def close
    @close = true
  end

  def close?
    @close
  end

  def _SCRIPT_PARSER_(yield_stack, path:, ext_name:, parser:)
    require_relative path
    @script_parser[ext_name] = [
      Module.const_get(parser).new,
      Module.const_get(parser)::Replacer.new]
  end

  #ネイティブコードを読み込む
  def _LOAD_NATIVE_(yield_stack, _ARGUMENT_:)
    require _ARGUMENT_
  end
end

end