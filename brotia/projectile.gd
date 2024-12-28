extends CharacterBody2D

var pos:Vector2
var rot:float
var dir:Vector2
var speed = 600.0
var slow_down = 0.5

@onready var _prev_pos = global_position

func _ready() -> void:
	global_position = pos
	global_rotation = rot

func _physics_process(delta: float) -> void:
	velocity= dir*speed
	speed = lerp(speed,0.0,slow_down*delta*10)
	move_and_slide()
	var distance_moved = _prev_pos.distance_to(global_position)
	if distance_moved < 1*delta:
		queue_free()
	_prev_pos = global_position 
