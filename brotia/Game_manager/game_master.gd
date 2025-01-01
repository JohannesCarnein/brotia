extends Node
class_name GAMEMASTER

@export var world2D:Node2D
@export var gui:Control

var current_scene_2D
var current_gui_scene

func _ready() -> void:
	Globals.gGM = self
	var mainmenu = "res://Game_manager/mainmenu.tscn"
	change_gui_scene(mainmenu)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ESC"):
		current_gui_scene.escape_pressed()

func change_2D_scene(new_scene: String, delete: bool = true, keep_running: bool = false)->void:
	if current_scene_2D != null:
		if delete:
			if current_scene_2D.has_method("pre_queue_free"):
				await current_scene_2D.pre_queue_free()
			current_scene_2D.queue_free()
		elif keep_running:
			if current_scene_2D.has_method("pre_hide"):
				await current_scene_2D.pre_hide()
			current_scene_2D.visible = false
		else:
			if current_scene_2D.has_method("pre_remove"):
				await current_scene_2D.pre_remove()
			gui.remove_child(current_scene_2D)
	var new = load(new_scene).instantiate()
	gui.add_child(new)
	current_scene_2D = new

func change_gui_scene(new_scene: String, delete: bool = true, keep_running: bool = false)->void:
	if current_gui_scene != null:
		if delete:
			if current_gui_scene.has_method("pre_queue_free"):
				await current_gui_scene.pre_queue_free()
			current_gui_scene.queue_free()
		elif keep_running:
			if current_gui_scene.has_method("pre_hide"):
				await current_gui_scene.pre_hide()
			current_gui_scene.visible = false
		else:
			if current_gui_scene.has_method("pre_remove"):
				await current_gui_scene.pre_remove()
			gui.remove_child(current_gui_scene)
	var new = load(new_scene).instantiate()
	gui.add_child(new)
	current_gui_scene = new

func exit_game():
	get_tree().quit()
	
