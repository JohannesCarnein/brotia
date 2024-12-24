extends Camera2D

@export var zoom_speed = 0.1
@export var zoom_max = 3
@export var zoom_min = 0.5


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("zoom_in"):
		zoom.x += zoom_speed
		zoom.y += zoom_speed
	elif event.is_action_pressed("zoom_out"):
		zoom.x -= zoom_speed
		zoom.y -= zoom_speed
	
