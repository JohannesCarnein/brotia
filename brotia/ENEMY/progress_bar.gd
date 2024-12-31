extends ProgressBar


func _on_health_component_health_changed(health: Variant) -> void:
	print("current health changed ", get_parent().name)
	value = health


func _on_health_component_max_health_changed(health: Variant) -> void:
	print("max health changed ", get_parent().name)
	max_value = health
