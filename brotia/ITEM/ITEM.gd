extends Node
class_name ITEM
signal pickup

@export var Item_ID = 0
@export var space_required = 1

func _pickup():
	pickup.emit()
	destroy()
	
func destroy():
	self.queue_free()
