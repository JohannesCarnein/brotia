extends Control


func _on_exit_pressed() -> void:
	Globals.gGM.exit_game()


func _on_start_game_pressed() -> void:
	Globals.gGM.change_2D_scene("res://Levels/dev_stage_01/Dev_dungeon_test.tscn")
	hide()

func _process(delta: float) -> void:
	if self.visible:
		update_scale()

func update_scale():
	if Globals.gCam:
		self.scale = Vector2.ONE/Globals.gCam.CAM.zoom
		self.global_position = Globals.gCam.CAM.global_position

func escape_pressed():
	visible = not visible
