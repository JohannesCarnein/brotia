extends Node2D
class_name HAND

signal pickup
signal use_item_signal
signal remove_item_signal

var Item : ITEM

	
func use():
	use_item_signal.emit()


func _on_inventory_main_hand_changed(item: Variant) -> void:
	%Weapon.update_item(item)
