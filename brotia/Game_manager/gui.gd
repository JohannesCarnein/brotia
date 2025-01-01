extends Control

func _process(delta: float) -> void:
	if Globals.gCam:
		global_position = Globals.gCam.global_position
