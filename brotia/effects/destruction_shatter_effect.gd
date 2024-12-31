extends EFFEKT

var color_texture:Texture2D


func trigger_effekt():
	texture = color_texture
	emitting = true
	await get_tree().create_timer(lifetime).timeout
	destroy()
	
func destroy():
	queue_free()
