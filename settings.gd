extends GridContainer


# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_fps_item_selected(index):
	if index == 0: Engine.max_fps = 30
	elif index == 1: Engine.max_fps = 60
	elif index == 2: Engine.max_fps = INF


func _on_back_to_home_pressed():
	get_tree().change_scene_to_file("res://home.tscn")


func _on_show_vec_toggled(toggled_on):
	Global.show_vec = toggled_on


func _on_show_dot_grid_toggled(toggled_on):
	Global.show_dot_grid = toggled_on
