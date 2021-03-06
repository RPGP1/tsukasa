#! ruby -E utf-8
require 'pp'
require 'minitest/test'
require 'minitest/mock'
require './system/Tsukasa.rb'

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

MiniTest.autorun

#DXRuby::Inputカスタムクラス
class TestInput
  #DXRuby::Input.key_down?をフックする
  def self.key_down?(pad_code)
    #引数でK_Z（Ｚキー）が指定された場合はtrueを返す
    if pad_code == Tsukasa::K_Z
      return true
    else
      return false
    end
  end

  #フックされていないメソッドについてはDXRuby::Inputのメソッドをそのまま渡す
  def self.method_missing(command_name, options)
    return DXRuby::Input.send(command_name, options)
  end
end

class TestInputBase < Minitest::Test
  #ゲーム側で判定タイミングのトリガーを用意するテスト
  def test_2017_02_08_1_キー入力確認_minitest_mock
    #DXRuby::Inputを模倣するモックオブジェクトを生成する
    test_module_mock = MiniTest::Mock.new
    #Input.key_down?(Tsukasa::K_Z)が実行された時に返す真偽値を設定する
    #１フレーム目：false
    test_module_mock.expect :call, false, [Tsukasa::K_Z]
    #２フレーム目：false
    test_module_mock.expect :call, false, [Tsukasa::K_Z]
    #３フレーム目：true←ここで_CHECK_が成立する
    test_module_mock.expect :call, true, [Tsukasa::K_Z]

    #スタブを設定する
    DXRuby::Input.stub(:key_down?,  test_module_mock) do
    
      #このブロック内でInput.key_down?が実行されるとtest_module_mockが代わりに呼びだされる。
    
      puts "zキーを押してください"
      #コントロールの生成
      control = Tsukasa::Control.new() do
        #動的プロパティの追加
        _DEFINE_PROPERTY_ test: nil
        #無限ループ
        _LOOP_ do
          #Inputオブジェクトをモックのクラスを指定して生成
          _CREATE_ :Input, id: :input
          #zキーが押された場合
          _CHECK_ [:_ROOT_, :input], key_down: Tsukasa::K_Z do
            #プロパティに値を設定
            _SET_ test: Tsukasa::K_Z
            #メインループを終了する
            _EXIT_
          end
          #１フレ送る
          _HALT_
        end
      end
      #メインループ
      DXRuby::Window.loop() do
        control.update(DXRuby::Input.mouse_x, DXRuby::Input.mouse_y) #処理
        control.render(0, 0, DXRuby::Window) #描画
        break if control.exit #メインループ終了判定
      end

      assert_equal(control.test, Tsukasa::K_Z)
    end

    #テスト
  end

  #ゲーム側で判定タイミングのトリガーを用意するテスト
  def test_2017_02_08_2_キー入力確認_カスタムクラスを使用
    puts "zキーを押してください"
    #コントロールの生成
    control = Tsukasa::Control.new() do
      #動的プロパティの追加
      _DEFINE_PROPERTY_ test: nil
      #無限ループ
      _LOOP_ do
        #Inputオブジェクトをモックのクラスを指定して生成
        _CREATE_ :Input, id: :input , _INPUT_API_: TestInput
        #zキーが押された場合
        _CHECK_ [:_ROOT_, :input], key_down: Tsukasa::K_Z do
          #プロパティに値を設定
          _SET_ test: Tsukasa::K_Z
          #メインループを終了する
          _EXIT_
        end
        #１フレ送る
        _HALT_
      end
    end
    #メインループ
    DXRuby::Window.loop() do
      control.update(DXRuby::Input.mouse_x, DXRuby::Input.mouse_y) #処理
      control.render(0, 0, DXRuby::Window) #描画
      break if control.exit #メインループ終了判定
    end

    #テスト
    assert_equal(control.test, Tsukasa::K_Z)

  end
end
