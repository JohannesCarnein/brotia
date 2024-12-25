extends Node2D

@onready var CAM = %Camera2D
@export var Target : Node2D

var gpos = self.global_position
var aiming = false

func _physics_process(delta: float) -> void:
	var pos = Target.global_position
	self.global_position = lerp(gpos, pos, 0.1)
	gpos = self.global_position

func _input(event: InputEvent) -> void:
	if "cam" in event.as_text():
		CAM._input(event)
