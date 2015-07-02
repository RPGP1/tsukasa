#! ruby -E utf-8

#ボタンコントロール
create :ButtonControl, 
        :x_pos => 0, 
        :y_pos => 0, 
        :id=>:button1 do
  create :ImageControl, 
         :file_path=>"./sozai/button_normal.png", 
         :id=>:normal
  create :ImageControl, 
        :file_path=>"./sozai/button_over.png", 
        :id=>:over,
        :visible => false
  create :ImageControl, 
        :file_path=>"./sozai/button_key_down.png", 
        :id=>:key_down,
        :visible => false
  create :ImageControl, 
        :file_path=>"./sozai/button_key_up.png", 
        :id=>:key_up,
        :visible => false
  create :ImageControl, 
        :file_path=>"./sozai/button_out.png", 
        :id=>:out,
        :visible => false
  normal
end

about :button1 do
  _IF_ -> {3 ** 3 == 30} do
    _THEN_ do
      move_line x: 300, y: 0,   count:0, frame: 60, start_x: 0,   start_y: 0
      wait_command :move_line
      move_line x: 300, y: 300, count:0, frame: 60, start_x: 300, start_y: 0
      wait_command :move_line
      move_line x: 0,   y: 300, count:0, frame: 60, start_x: 300, start_y: 300
      wait_command :move_line
      move_line x: 0,   y: 0,   count:0, frame: 60, start_x: 0,   start_y: 300
      wait_command :move_line
    end
    _ELSIF_ -> {2 ** 2 == 4} do
      move_line x: 300, y: 300,   count:0, frame: 60, start_x: 0,   start_y: 0
      wait_command :move_line
      move_line x: 300, y: 0, count:0, frame: 60, start_x: 300, start_y: 300
      wait_command :move_line
      move_line x: 0,   y: 300, count:0, frame: 60, start_x: 300, start_y: 0
      wait_command :move_line
      move_line x: 0,   y: 0,   count:0, frame: 60, start_x: 0,   start_y: 300
      wait_command :move_line
    end
    _ELSE_ do
      move_line x: 0, y: 300,   count:0, frame: 60, start_x: 0,   start_y: 0
      wait_command :move_line
      move_line x: 300, y: 300, count:0, frame: 60, start_x: 0, start_y: 300
      wait_command :move_line
      move_line x: 300,   y: 0, count:0, frame: 60, start_x: 300, start_y: 300
      wait_command :move_line
      
      _IF_ -> {4 ** 4 < 300} do
        _THEN_ do
          move_line x: 0,   y: 0,   count:0, frame: 60, start_x: 300,   start_y: 0
          wait_command :move_line
        end
        _ELSE_ do
          move_line x: 0,   y: 300,   count:0, frame: 60, start_x: 300,   start_y: 0
          wait_command :move_line
        end
      end
    end
  end
end
