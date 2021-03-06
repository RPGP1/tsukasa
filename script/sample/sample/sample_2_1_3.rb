#ボタンコントロール
_CREATE_ :ClickableLayout, 
        shape: [0,0,256,256],
        width: 256,
        height: 256,
        id: :test01,
        colorkey_id: :normal,
        colorkey_border:200 do
  _CREATE_ :Image, path: "./resource/star_button.png", 
    id: :normal
  _CREATE_ :Image, path: "./resource/button_over.png", 
    id: :over, visible: false
  _CREATE_ :Image, path: "./resource/button_key_down.png", 
    id: :key_down, visible: false

  _DEFINE_ :inner_loop do
    _CHECK_ collision: :cursor_over do
      _SEND_(:normal)  {_SET_ visible: false}
      _SEND_(:over)    {_SET_ visible: true}
      _SEND_(:key_down){_SET_ visible: false}
    end
    _CHECK_ collision: :cursor_out do
      _SEND_(:normal)  {_SET_ visible: true}
      _SEND_(:over)    {_SET_ visible: false}
      _SEND_(:key_down){_SET_ visible: false}
    end
    _CHECK_ collision: :key_down do
      _SEND_(:normal)  {_SET_ visible: false}
      _SEND_(:over)    {_SET_ visible: false}
      _SEND_(:key_down){_SET_ visible: true}
    end
    _CHECK_ collision: :key_up do
      _SEND_(:normal)  {_SET_ visible: false}
      _SEND_(:over)    {_SET_ visible: true}
      _SEND_(:key_down){_SET_ visible: false}
    end
    _HALT_
    _RETURN_ do
      inner_loop
    end
  end
  inner_loop
end

_WAIT_ input:{mouse: :right_push}

_SEND_ :test01, interrupt: true do
  _DELETE_
end
