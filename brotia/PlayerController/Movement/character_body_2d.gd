extends CharacterBody2D

@onready var CAM = %Camera2D
@onready var PLAYER_SPRITE = %Sprite2D

var look_direction = Vector2(0,0)

const SPEED = 300.0
const JUMP_VELOCITY = -400.0


func _input(event: InputEvent) -> void:
	CAM._input(event)

func _physics_process(delta: float) -> void:

	var right := Input.get_axis("move_left", "move_right")
	var up := Input.get_axis("move_up", "move_down")
	var direction = Vector2(right,up)
	if direction:
		velocity = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.y = move_toward(velocity.y, 0, SPEED)
	
	move_and_slide()
	if velocity.length() > 0:
		set_sprite_direction(direction)

func set_sprite_direction(direction):
	if direction.x >= 0:
		PLAYER_SPRITE.flip_h = 0
	else:
		PLAYER_SPRITE.flip_h = 1
	look_direction = direction
	
	
