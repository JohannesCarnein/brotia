extends Control
class_name INVENTORY
signal items_changed(itemindex)
signal active_changed(item)
signal focus_changed(item)
signal main_hand_changed(item)

@onready var Grid = %GridContainer
@onready var Equipment = %Equipment
@export var space = 50
var active_item
var focused_item
var Areas = []

func _ready() -> void:
	build_Areas()
	self.visible = false

func build_Areas():
	Areas.append(Grid)
	Areas.append(Equipment)

func set_item(area,index, item):
	print(area,"  ", index, "  ", item)
	var prev_item = Areas[area].content[index]
	print(prev_item)
	
	Areas[area].update_icon(index,item)
	return prev_item

func check_space(space_required:int):
	var i = -1
	for area in Areas:
		i += 1
		if area:
			var inv_id = area.content.find(null)
			if inv_id >= 0:
				break
	var inv_id = Areas[i].content.find(null)
	if inv_id >= 0:
		return inv_id
	else:
		return -1
	
func remove_item(area,index):
	var prev_item = Areas[area].content[index]
	Areas[area].content[index] = null
	#emit_signal("items_changed", [index])
	Areas[area].update_icon(index, 0)
	return prev_item
	
func get_area_under_cursor(cursor_pos):
	var i = -1
	for area in Areas:
		i += 1
		if area:
			var rect = area.get_global_rect()
			if rect.has_point(cursor_pos):
				return i
	return -1
	
func get_item_under_cursor(cursor_pos):
	var area_id = get_area_under_cursor(cursor_pos)
	
	if area_id > -1:
		var area = Areas[area_id]
		var i = -1
		for slot in area.Slots:
			i += 1
			var rect = slot.get_global_rect()
			if rect.has_point(cursor_pos):
				return [area_id,i]
				
		return [null,null]
	else:
		return [null,null]
	
func set_active(area,index):
	if active_item != null:
		Grid.Slots[active_item].set_active(false)
	active_item = index
	Grid.Slots[index].set_active(true)
	var item = Areas[area].Slots[index].Item_id
	emit_signal("active_changed", item)
	
func set_focus(area,index):
	var item = null
	if index != null:
		item = Areas[area].Slots[index].Item_id
	if focused_item != index and item != null:
		emit_signal("focus_changed", item)
	
func input(event):
	if event.is_action_pressed("Inv"):
		self.visible = !self.visible
		
func update_scale():
	if Globals.gCam:
		self.scale = Vector2.ONE/Globals.gCam.CAM.zoom
		
func _process(delta: float) -> void:
	if self.visible:
		update_scale()
