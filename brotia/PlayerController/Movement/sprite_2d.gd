extends AnimatedSprite2D

func _physics_process(delta: float) -> void:
	var prev_rot = rotation
	var target = get_global_mouse_position()
	look_at(target)
	#rotation = lerp(prev_rot,rotation,0.9)
	#if flip_h == true:
		#rotate(deg_to_rad(180))
	
