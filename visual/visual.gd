extends Node2D

var loaded_files = 0
var load_thread: Thread
var handles = []
var root_rect = Rect2(0, 0, 300, 300) # 假设一个初始的绘制区域
var font = ThemeDB.fallback_font;

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
	$TextEdit.text = JSON.stringify(handles, " ", false)
	queue_redraw()

func _draw():
	_draw_handle_tree(handles, root_rect)
	#_draw_outer_frame(Global.dir)

func _draw_handle_tree(handles: Array, rect: Rect2):
	var x_offset = rect.position.x
	var y_offset = rect.position.y
	for handle in handles:
		var handle_rect = Rect2(x_offset, y_offset, 100, 50) # 简单示例，假设每个矩形的大小为 100x50
		if handle["kind"] == "directory":
			draw_rect(handle_rect, Color(0, 0, 1, 0.1)) # 蓝色半透明背景表示目录
			#draw_string(get_font("font"), handle_rect.position, handle["name"], Color(1, 1, 1))
			draw_string(font, handle_rect.position, handle["name"])
			_draw_handle_tree(handle["children"], handle_rect)
		else:
			draw_rect(handle_rect, Color(0, 1, 0, 0.1)) # 绿色半透明背景表示文件
			draw_string(font, handle_rect.position, handle["name"])
		y_offset += 60 # 每个矩形之间的垂直间距为 60

#func _draw_outer_frame(path: String):
	#var name = path.get_file() # 获取路径的最后一个斜杠后的内容
	#draw_rect(root_rect, Color(0, 0, 1)) # 蓝色边框
	#draw_string(font, root_rect.position, name)

func get_font(name: String) -> Font:
	return $FontHolder.get_font(name) # 假设有一个节点 FontHolder 存储字体
