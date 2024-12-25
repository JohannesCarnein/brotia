extends Control
class_name INVENTORY
signal items_changed(itemindex)

@onready var Grid = %GridContainer
@export var space = 50
var content:Array = []

func _ready() -> void:
	self.visible = false
	for i in range(space):
		content.append(null)
	print(content)
	Grid.init(content)

func set_item(index, item):
	var prev_item = content[index]
	content[index] = item
	emit_signal("items_changed", [index])
	return prev_item
	
func swap_item(index,target_index):
	var target_item = content[target_index]
	var item = content[index]
	content[target_index] = item
	content[index] = target_item
	emit_signal("items_changed", [index,target_index])
	
func check_space(space_required):
	pass	
	
func remove_item(index):
	var prev_item = content[index]
	content[index] = null
	emit_signal("items_changed", [index])
	return prev_item
	
func input(event):
	if event.is_action_pressed("Inv"):
		self.visible = !self.visible
		
