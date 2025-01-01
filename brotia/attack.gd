extends Resource
class_name ATTACK

var damage:float
var impulse_direction:Vector2
var impulse_strength:float 

func _init(damage: float) -> void:
	self.damage = damage
