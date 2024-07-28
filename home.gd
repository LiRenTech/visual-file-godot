extends Control

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float):
	pass

func _on_file_dialog_dir_selected(dir: String):
	Global.dir = dir
	get_tree().change_scene_to_file("res://visual.tscn")

func _on_button_open_folder_pressed():
	$FileDialog.visible = true
