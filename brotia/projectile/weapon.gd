extends Node2D
var projectile_path = preload("res://projectile/projectile.tscn")
@export var number_of_projectiles = 1
@export var spread = 0.1

func _ready() -> void:
	var callable = Callable(self,"use")
	get_parent().use_item_signal.connect(callable)

func _physics_process(delta: float) -> void:
	look_at(get_global_mouse_position())
	
func can_be_usesed():
	return true
	
func use():
	if can_be_usesed():
		for i in number_of_projectiles:
			var offset = randf_range(-spread,spread)
			var projectile = projectile_path.instantiate()
			projectile.dir = Vector2(1.0,0).rotated(rotation).rotated(offset)
			projectile.start_pos = global_position
			projectile.start_rot = global_rotation
			get_tree().root.add_child(projectile)
			await get_tree().create_timer(0.03).timeout
