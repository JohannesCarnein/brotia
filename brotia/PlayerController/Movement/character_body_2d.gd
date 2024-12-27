extends CharacterBody2D

@onready var PLAYER_SPRITE = %Sprite2D
@onready var MAINHAND = %MAINHAND
@onready var INV = %INVENTORY

var look_direction = Vector2(0,0)

@export var SPEED = 300.0

func _ready() -> void:
	connect_to_Globals()
	
func connect_to_Globals():
	Globals.gPlayer = self

func _input(event: InputEvent) -> void:
	if event.is_action("hand_use_main"):
		MAINHAND.use()
	
	if event.is_action("Inv"):
		INV.input(event)

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
	
	
