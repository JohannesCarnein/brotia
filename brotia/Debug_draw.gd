extends Node

var default_thickness = 2

func draw_line(start: Vector2, end: Vector2, persist_ms = 500, color = Color.WHITE):
	var line := Line2D.new()
	line.z_as_relative = false
	line.z_index = 100
	line.width = default_thickness
	line.default_color = color
	line.add_point(start)
	line.add_point(end)
	final_cleanup(line, persist_ms)
	
func draw_point(pos: Vector2, persist_ms = 500, color = Color.WHITE):
	var radius = default_thickness/2
	var circle:ColorRect = ColorRect.new()
	circle.global_position = pos
	circle.z_as_relative = false
	circle.z_index = 100
	circle.color = color
	circle.size = Vector2(radius * 2, radius * 2)
	circle.custom_minimum_size = Vector2(radius * 2, radius * 2)
	circle.position = pos - Vector2(radius, radius)
	final_cleanup(circle, persist_ms)
	
func draw_text(text: String, pos:Vector2 = Vector2.ZERO, persist_ms = 500, color = Color.WHITE):
	var mesh_instance:MeshInstance2D = MeshInstance2D.new()
	var text_mesh:TextMesh = TextMesh.new()
	text_mesh.text = text
	text_mesh.pixel_size = 1
	text_mesh.font_size = 10
	mesh_instance.mesh = text_mesh
	mesh_instance.scale.y = -1.0
	color.a = 1.0
	mesh_instance.self_modulate = color
	mesh_instance.global_position = pos
	mesh_instance.z_as_relative = false
	mesh_instance.z_index = 100
	final_cleanup(mesh_instance, persist_ms)
	

## 1 -> Lasts ONLY for current physics frame
## >1 -> Lasts X time duration.
## <1 -> Stays indefinitely
func final_cleanup(mesh_instance, persist_ms: float):
	#print(mesh_instance, persist_ms)
	get_tree().get_root().add_child.call_deferred(mesh_instance)
	#mesh_instance.global_position = Vector2.ZERO
	#print(get_tree().get_root())
	if persist_ms == 1:
		await get_tree().physics_frame
		mesh_instance.queue_free()
	elif persist_ms > 0:
		await get_tree().create_timer(persist_ms/1000).timeout
		mesh_instance.queue_free()
	else:
		return mesh_instance
	
