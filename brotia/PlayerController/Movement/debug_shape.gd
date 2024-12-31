extends Sprite2D

var time = 0.0
var end_time = 10.0

func _ready() -> void:
	var destruction_effekt = preload("res://effects/destruction_shatter_effect.tscn")
	var effekt = destruction_effekt.instantiate()
	get_tree().root.add_child(effekt)
	effekt.global_position = global_position
	var colors = []
	for c in len(effekt.emission_colors):
		var brightness = randf()
		var color = Color.SLATE_GRAY*lerp(brightness,0.3,0.8)
		color.a = 0.7
		colors.append(color)
	effekt.emission_colors = colors
	effekt.amount = 10
	effekt.lifetime = 0.6
	effekt.speed_scale = 0.1
	effekt.explosiveness = 1
	effekt.spread = 180
	effekt.damping_min = 500
	effekt.global_rotation = global_rotation
	effekt.rotate(deg_to_rad(90))
	effekt.trigger_effekt()

func _process(delta: float) -> void:
	time += delta
	if time >= end_time:
		destroy()
	modulate.a = (end_time-time)/end_time
	
	
func destroy():
	#print("destruct")
	queue_free()
