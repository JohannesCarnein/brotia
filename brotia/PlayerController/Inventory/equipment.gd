extends Panel

var content:Array = [null,null,null]
var Slots = []

func _ready() -> void:
	for child in get_children():
		if child is SLOT:
			Slots.append(child)
	print(Slots)

func update_icon(id, item):
	content[id] = item
	Slots[id].update(item)
