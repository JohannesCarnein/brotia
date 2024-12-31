extends Node2D
class_name HEALTH_COMPONENT

signal max_health_changed(health)
signal health_changed(health)
signal health_empty

@export var max_health:float = 100.0:
	set(value):
		if value != max_health:
			current_health = value
			max_health_changed.emit(max_health)
@export var current_health:float = 100.0:
	set(value):
		if value != current_health:
			current_health = min(max_health,value)
			health_changed.emit(current_health)
			if current_health <= 0.0:
				health_empty.emit()
@export var regen_factor:float = 0.01
@export var regen_rate:float = 2.0
@export var can_regenerate:bool = true

var _is_regenerating:bool = false

func _ready() -> void:
	max_health_changed.connect(check_for_regen)
	health_changed.connect(check_for_regen)

func check_for_regen(health):
	if current_health < max_health:
		regenerate_health()

func regenerate_health():
	if can_regenerate and _is_regenerating == false:
		#print("regenerating ", get_parent().name))
		_is_regenerating = true
		var health_gain = max_health * regen_factor
		await get_tree().create_timer(regen_rate).timeout
		var target_health = min(max_health,current_health+health_gain)
		_is_regenerating = false
		current_health = target_health
	
	
