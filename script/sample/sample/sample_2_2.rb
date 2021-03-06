_CREATE_ :TileMap, 
  map_array: [[0]], size_x: 1, size_y: 1, width:32, height:32, id: :test01 do
  _SET_TILE_GROUP_ path: "./resource/icon/icon_4_a.png",
    x_count: 4, y_count: 1

  _DEFINE_ :inner_loop do
    _MAP_STATUS_ 0
    _WAIT_ count: 5
    _MAP_STATUS_ 1
    _WAIT_ count: 5
    _MAP_STATUS_ 2
    _WAIT_ count: 5
    _MAP_STATUS_ 3
    _WAIT_ count: 5
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
