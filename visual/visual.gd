extends Node2D

#var pos = Vector2(100, 100)
#var drag_pos = Vector2(0, 0)
#var size = Vector2(100, 100)
#var dragging = false

func load(path: String):
	for file in DirAccess.get_files_at(path):
		pass
	for dir in DirAccess.get_directories_at(path):
		pass

func _ready():
	pass

func _process(delta):
	$Info.text = "FPS: %d\nDir: %s" % [
		Engine.get_frames_per_second(),
		Global.dir
	]
	#var mouse_pos = get_viewport().get_mouse_position()
	#if (
		#(
			#Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT)
			#and mouse_pos <= pos + size
			#and mouse_pos >= pos
		#) or (
			#Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT)
			#and dragging
		#)
	#):
		#if not dragging:
			#drag_pos = mouse_pos - pos
		#dragging = true
		#pos = mouse_pos - drag_pos
		#queue_redraw()
	#else:		#dragging = false

func _draw():
	pass
