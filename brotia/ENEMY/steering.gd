extends Node2D
class_name STEERING

var raycasts:Array[RayCast2D] = []

func _ready() -> void:
	for child in get_children():
		if child is RayCast2D:
			raycasts.append(child)

func check_for_collision():
	var angle:float = 0.0
	for raycast in raycasts:
		if raycast.is_colliding():
			var raycast_dir = raycast.target_position
			var raycast_length = raycast_dir.length()
			var collision_distance = raycast.global_position.distance_to(raycast.get_collision_point())
			var collision_normal = raycast.get_collision_normal()
			var collision_normal_dot_product = -collision_normal.dot(Vector2.RIGHT)
			var collision_factor = 1 - collision_distance / raycast_length
			var raycast_angle = Vector2.RIGHT.angle_to(raycast_dir)
			angle -= raycast_angle * collision_factor*2 #* (1-collision_normal_dot_product)
	return angle
