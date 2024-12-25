extends GridContainer

var Icon_Base = preload("res://PlayerController/Inventory/inv_icon.tscn")
var Icons = []

func init(content):
	for item in content:
		var Icon = Icon_Base.instantiate()
		Icon.update(item)
		self.add_child(Icon)
		Icons.append(Icon)


func _on_inventory_items_changed(itemindex: Variant) -> void:
	pass # Replace with function body.
