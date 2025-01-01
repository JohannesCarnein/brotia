class_name PROJECTILE_POTATO
extends CharacterBody2D

@export var number_of_possible_hits:int = 1

var attack_damage: int = 10
var destruction_effekt = preload("res://effects/destruction_shatter_effect.tscn")
var start_pos:Vector2
var start_rot:float
var dir:Vector2
var max_speed = 600.0
var speed = 600.0
var slow_down = 0.5
var attack:ATTACK = ATTACK.new(10)


var _distance_moved

@onready var collision = %CollisionShape2D
@onready var _prev_pos = global_position


func load_texture(path: String) -> Texture2D:
	var image_texture := ImageTexture.new()
	var image := Image.load_from_file(path)
	image_texture = image_texture.create_from_image(image)
	return image_texture

func _init(name: String) -> void:
	if name == "Potato":
		%Sprite2D.texture


func _ready() -> void:
	global_position = start_pos
	global_rotation = start_rot

func _physics_process(delta: float) -> void:
	velocity= dir*speed
	speed = lerp(speed,0.0,slow_down*delta*10)
	move_and_slide()
	_distance_moved = _prev_pos.distance_to(global_position)
	if _distance_moved < 1*delta:
		destroy()
	_prev_pos = global_position 

func destroy(impact_pos=global_position):
	var effekt = destruction_effekt.instantiate()
	get_tree().root.add_child(effekt)
	effekt.global_position = global_position
	effekt.direction = lerp(velocity.normalized(),impact_pos.direction_to(global_position).normalized(),0.4)*speed
	var actual_velocity = velocity.normalized()*_distance_moved
	var spread_factor = clamp(actual_velocity.length()/max_speed*100,0.0,1.0)
	#print(max_speed," ",actual_velocity.length()," ",spread_factor)
	effekt.spread = lerp(180.0,0.0,spread_factor)
	effekt.lifetime *= lerp(0.3,2.0,spread_factor)
	effekt.speed_scale *= lerp(0.5,2.5,spread_factor)
	effekt.trigger_effekt()
	queue_free()

func _on_area_2d_area_entered(area: Area2D) -> void:
	if area is HITBOX:
		if number_of_possible_hits > 0:
			if area.recive_attack(attack):
				number_of_possible_hits -= 1
				if number_of_possible_hits <= 0:
					destroy(area.global_position)
