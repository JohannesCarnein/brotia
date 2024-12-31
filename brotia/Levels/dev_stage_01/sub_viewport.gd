extends SubViewport

func _process(delta: float) -> void:
	global_canvas_transform.origin = Globals.gPlayer.global_position
