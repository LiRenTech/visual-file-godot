extends Node2D

var loaded_files := 0
var load_thread: Thread
var handles = []
var font := ThemeDB.fallback_font
var canvas_pos := Vector2(0, 0)
var canvas_drag_pos := Vector2(0, 0)
var canvas_dragging := false
var dot_gap := 30
var full_redraw = false

func _load_dir(path: String) -> Array:
	var dir = DirAccess.open(path)
	if dir:
		var handles = []
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			loaded_files += 1
			if dir.current_is_dir():
				handles.append({
					"kind": "directory",
					"name": file_name,
					"children": _load_dir(path + "/" + file_name)
				})
			else:
				handles.append({
					"kind": "file",
					"name": file_name
				})
			file_name = dir.get_next()
		return handles
	else:
		return [{"kind": "error"}]

func _load_thread_func():
	handles = _load_dir(Global.dir)

func _ready():
	load_thread = Thread.new()
	load_thread.start(_load_thread_func)
	_full_redraw()

func _process(delta):
	get_node("../Info").text = "FPS: %d\nDir: %s\nLoaded: %d" % [
		Engine.get_frames_per_second(),
		Global.dir,
		loaded_files
	]
	var mouse_pos = get_viewport().get_mouse_position()
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_MIDDLE):
		if not canvas_dragging:
			canvas_drag_pos = mouse_pos - canvas_pos
		canvas_dragging = true
		canvas_pos = mouse_pos - canvas_drag_pos
		queue_redraw()
	else:
		canvas_dragging = false
	self.position = canvas_pos

func _full_redraw():
	full_redraw = true
	queue_redraw()

func _draw():
	if full_redraw:
		full_redraw = false
		_draw_dot_grid()
		return
	if canvas_dragging and Global.show_dot_grid:
		_draw_dot_grid()

func _draw_dot_grid():
	var start_pos := canvas_pos
	if canvas_pos.x < 0:
		while start_pos.x <= dot_gap:
			start_pos.x += dot_gap
	else:
		while start_pos.x >= dot_gap:
			start_pos.x -= dot_gap
	start_pos.x -= canvas_pos.x
	if canvas_pos.y < 0:
		while start_pos.y <= dot_gap:
			start_pos.y += dot_gap
	else:
		while start_pos.y >= dot_gap:
			start_pos.y -= dot_gap
	start_pos.y -= canvas_pos.y
	var drew := start_pos
	drew.y -= dot_gap
	while drew.y - start_pos.y <= get_viewport_rect().size.y:
		drew.x -= dot_gap
		while drew.x - start_pos.x <= get_viewport_rect().size.x:
			var vec = Vector2(int(drew.x / dot_gap), int(drew.y / dot_gap))
			draw_circle(drew, 2, Color(0.1, 0.1, 0.1))
			if Global.show_vec:
				draw_string(
					font,
					Vector2(drew.x, drew.y + 15),
					"%d,%d" % [vec.x, vec.y],
					HORIZONTAL_ALIGNMENT_LEFT,
					-1,
					10,
					Color(0.2, 0.2, 0.2)
				)
			drew.x += dot_gap
		drew.x = start_pos.x
		drew.y += dot_gap
