extends Node2D
class_name HAND

signal pickup
signal use_item_secondary_signal
signal use_item_main_signal
signal remove_item_signal


var Item : ITEM

func _ready():
	%Weapon.finish_init()


func use():
	use_item_main_signal.emit()


func _on_inventory_main_hand_changed(item: Variant) -> void:
	%Weapon.update_item(item)
