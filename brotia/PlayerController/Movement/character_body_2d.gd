extends CharacterBody2D

@onready var Animated_PLAYER_SPRITE = %AnimatedSprite2D
@onready var Animated_arm_l = %Sprite2D3
@onready var Animated_arm_r = %Sprite2D2
@onready var MAINHAND = %MAINHAND
@onready var INV = %INVENTORY
@onready var COLLISION = %CollisionShape2D
@onready var walk_anim = preload("res://Art_Assets/Player/popelpete/anim/popelpete_walk.tres")
@onready var roll_anim = preload("res://Art_Assets/Player/popelpete/anim/popelpete_roll.tres")
@onready var debug_shape_ = preload("res://debug/breadcrumb.tscn")
@onready var stamina_bar = %ProgressBar
@onready var health_bar = %ProgressBar2

@onready var health_component = %HEALTH_COMPONENT

var anim_offset = 0.0
var look_direction = Vector2(0,0)
var framerate = 6
var _rolling = false
var _max_stamina

var breadcrumbs = []

@export var SPEED = 200.0
@export var STAMINA = 100.0
@export var stamina_regen_rate = 10.0
@export var dash_cost = 20.0
@export var dash_speed =150.0

func _ready() -> void:
	_max_stamina = STAMINA
	stamina_bar.max_value = _max_stamina
	stamina_bar.value = STAMINA
	connect_to_Globals()
	Animated_PLAYER_SPRITE.sprite_frames = walk_anim
	stamina_regen()
	drop_breadcrumb()
	
func drop_breadcrumb():
	var max_breadcrumbs = 10
	var intervall = 0.2
	if len(breadcrumbs) >= max_breadcrumbs:
		breadcrumbs.remove_at(0)
	if _rolling == false:
		breadcrumbs.append(global_position)
	else:
		breadcrumbs.append(breadcrumbs[-1])
	
	
	if velocity.length() > 0 and _rolling == false:
		var debug_shape = debug_shape_.instantiate()
		debug_shape.global_position = global_position
		debug_shape.look_at(global_position+velocity)
		debug_shape.rotate(deg_to_rad(90))
		get_tree().root.add_child(debug_shape)
		debug_shape.end_time = max_breadcrumbs*intervall
	
	await get_tree().create_timer(intervall).timeout
	drop_breadcrumb()
	
func connect_to_Globals():
	Globals.gPlayer = self
	Debug.draw_text("Moin ich bin PopelPete, das Kind, das lebte...", global_position+Vector2(0.0, 18.0), 3000, Color.GOLDENROD)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("hand_use_main"):
		MAINHAND.use()
	
	if event.is_action("Inv"):
		INV.input(event)
		
	if event.is_action_pressed("move_dash"):
		if _rolling == false:
			dash()


func dash():
	if check_stamina(dash_cost):
		anim_offset = 0
		_rolling = true
		Animated_PLAYER_SPRITE.sprite_frames = roll_anim
		await get_tree().create_timer(0.2).timeout
		Animated_PLAYER_SPRITE.sprite_frames = walk_anim
		_rolling = false
	
func stamina_regen():
	STAMINA = min(_max_stamina,STAMINA+stamina_regen_rate)
	stamina_bar.value = STAMINA
	await get_tree().create_timer(2.0).timeout
	stamina_regen()
	
	
func check_stamina(cost):
	if STAMINA >= cost:
		STAMINA -= cost
		stamina_bar.value = STAMINA
		return true
	else:
		return false

func _physics_process(delta: float) -> void:

	var right := Input.get_axis("move_left", "move_right")
	var up := Input.get_axis("move_up", "move_down")
	var direction = Vector2(right,up).normalized()
	if direction:
		if _rolling:
			velocity = direction * (SPEED + dash_speed)
		else:
			velocity = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.y = move_toward(velocity.y, 0, SPEED)
	if velocity.length() > 0:
		var animspeed_multiplyer = 300/SPEED
		anim_offset= anim_offset+1.0*delta*(framerate*animspeed_multiplyer)
		Animated_PLAYER_SPRITE.frame = int(anim_offset)%6
		Animated_arm_l.frame = int(anim_offset)%6
		Animated_arm_r.frame = int(anim_offset)%6
	else:
		anim_offset = 0.0
		Animated_PLAYER_SPRITE.frame = int(anim_offset)
		Animated_arm_l.frame = int(anim_offset)
		Animated_arm_r.frame = int(anim_offset)
	
	move_and_slide()
	if velocity.length() > 0:
		set_sprite_direction(direction)

func set_sprite_direction(direction):
	if direction.x >= 0:
		Animated_PLAYER_SPRITE.flip_h = 0
		Animated_arm_l.flip_h = 0
		Animated_arm_l.offset.x = 0
		Animated_arm_r.flip_h = 0
		Animated_arm_r.position.x = 5
		
	else:
		Animated_PLAYER_SPRITE.flip_h = 1
		Animated_arm_l.flip_h = 1
		Animated_arm_l.offset.x = 10
		Animated_arm_r.flip_h = 1
		Animated_arm_r.position.x = -5
	look_direction = direction
	
	
func modifiy_health(damage):
	health_component.current_health += damage

func _on_hitbox_component_attack_recieved(attack: ATTACK) -> void:
	var damage = -attack.damage
	modifiy_health(damage)
