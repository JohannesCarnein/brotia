extends Camera2D

@export var zoom_speed = 0.1
@export var zoom_max = 5
@export var zoom_min = 0.1

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("cam_zoom_in"):
		zoom.x = min(zoom.x+zoom_speed,zoom_max)
		zoom.y = min(zoom.y+zoom_speed,zoom_max)
	elif event.is_action_pressed("cam_zoom_out"):
		zoom.x = max(zoom.x-zoom_speed,zoom_min)
		zoom.y = max(zoom.y-zoom_speed,zoom_min)
	
