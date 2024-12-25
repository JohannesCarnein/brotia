extends Node2D
class_name HAND

signal pickup
signal use_item_signal
signal remove_item_signal

var Item : ITEM

func update_item():
	var children = self.get_children()
	if len(children) > 0 :
		for child in children:
			if child.get_class() == "ITEM":
				Item = child
				break

func add_item(item:ITEM):
	item.reparent(self)
	item.global_position = self.global_position
	Item = item
	Item.init(self)

func remove_item():
	remove_item_signal.emit()

func change_item(item:ITEM):
	remove_item()
	add_item(item)
	
func use():
	use_item_signal.emit()
