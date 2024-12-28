extends Node2D
var projectile_path = preload("res://projectile/projectile.tscn")

func _ready() -> void:
	var callable = Callable(self,"use")
	get_parent().use_item_signal.connect(callable)

func _physics_process(delta: float) -> void:
	look_at(get_global_mouse_position())
	
func use():
	var projectile = projectile_path.instantiate()
	projectile.dir = Vector2(1.0,0).rotated(rotation)
	projectile.pos = global_position
	projectile.rot = global_rotation
	get_tree().root.add_child(projectile)
