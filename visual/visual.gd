extends Node2D

var loaded_files = 0
var load_thread: Thread
var handles = []
var root_rect = Rect2(0, 0, 300, 300) # 假设一个初始的绘制区域
var font = ThemeDB.fallback_font

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

func _process(delta):
	$Info.text = "FPS: %d\nDir: %s\nLoaded: %d" % [
		Engine.get_frames_per_second(),
		Global.dir,
		loaded_files
	]
	queue_redraw()

func _draw():
	pass
