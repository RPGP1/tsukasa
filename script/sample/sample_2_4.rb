_CREATE_ :ClickableLayout, 
  width:256, 
  height:256 do
  _CREATE_ :TileMap, id: :icon, 
    width: 256,
    height: 256 do
    _SET_ map_array: [[0]]
    _SET_TILE_ 0, path: "./resource/button_normal.png"
    _SET_TILE_ 1, path: "./resource/button_over.png"
    _SET_TILE_ 2, path: "./resource/button_key_down.png"
  end

  _DEFINE_ :drug_control do
    #カーソルが画像の上に来るまで待機
    _WAIT_ do
      _CHECK_MOUSE_ :cursor_on do
        _BREAK_
      end
    end

    #画像を「OVER」に差し替える
    _SEND_ :icon do
      _MAP_STATUS_ 1
    end

    #キーがクリックされるまで待機
    _WAIT_ do
      _CHECK_MOUSE_ [:key_down, :cursor_out] do
        _BREAK_
      end
    end

    #カーソルが画像の外に移動した場合
    _CHECK_MOUSE_ :cursor_out do
      #画像を「NORMAL」に差し替える
      _SEND_ :icon do
        _MAP_STATUS_ 0
      end
      #ループの最初に戻る
      _RETURN_ do
        drug_control
      end
    end

    #画像を「DOWN」に差し替える
    _SEND_ :icon do
      _MAP_STATUS_ 2
    end

    #キーが離されるまで待機し、その間ブロックを実行する
    _WAIT_ do
      _CHECK_MOUSE_ :key_up do
        _BREAK_
      end
      #コントロールプロパティを取得
      _GET_ [:cursor_offset_x, :cursor_offset_y] do 
             |cursor_offset_x:, cursor_offset_y:|
        #コントロールのＸＹ座標にカーソルの移動オフセット値を加算
        _SET_OFFSET_ x: cursor_offset_x, y: cursor_offset_y
      end
    end
    _RETURN_ do
      drug_control
    end
  end
  
  drug_control
end

_LOOP_ do
  _END_FRAME_
end