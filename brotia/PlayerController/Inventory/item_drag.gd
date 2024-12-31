extends TextureRect

@onready var pos = self.position

var _area_from = null
var _index_from = null
var _holding = null
var _is_holding = false

func _process(delta: float) -> void:
	#var mouse_position = pos+get_viewport().get_mouse_position()
	var mouse_position = get_global_mouse_position()
	self.global_position = mouse_position
	#var item_loc = check_under_cursor()
	#var area = item_loc[0]
	#var item_id = item_loc[1]
	#Globals.gPlayer.INV.set_focus(item_id)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("hand_use_main"):
		var item_loc = check_under_cursor()
		var area = item_loc[0]
		var item_id = item_loc[1]
		if area != null and item_id != null:
			print("item ",item_id)
			if item_id != null:
				if item_id >= 0:
					if grab_under_cursor(area,item_id):
						_is_holding = true
	if event.is_action_released("hand_use_main"):
		if _is_holding == true:
			drop_item()
			

func check_under_cursor():
	#print("checking under cursor")
	var mouse_position = get_global_mouse_position()#pos+get_viewport().get_mouse_position()
	var item_id_under_cursor = Globals.gPlayer.INV.get_item_under_cursor(mouse_position)
	return item_id_under_cursor

func grab_under_cursor(area,item_id):
	#print("grab_under_cursor",item_id)
	var item = Globals.gPlayer.INV.Areas[area].Slots[item_id]
	if item :
		Globals.gPlayer.INV.set_active(area,item_id)
	item = Globals.gPlayer.INV.remove_item(area,item_id)
	if item :
		update(item)
		_area_from = area
		_index_from = item_id
		_holding = item
		return true
	else:
		return false

func update(item_id):
	if item_id == null:
		item_id = 0
	var texture_path = "res://ITEM/icons/ERROR_icon.png"
	#if ItemDB.Items[item_id]["icon"]:
	#	texture_path = ItemDB.Items[item_id]["icon"]
	#var image = Image.new()
	#image.load(texture_path)
	#var image_texture = ImageTexture.new()
	#image_texture.set_image(image)
	var image_texture = ItemDB.get_property_of_index(item_id,"texture")
	self.texture = image_texture

func drop_item():
	var item_loc = check_under_cursor()
	var area = item_loc[0]
	var item_id = item_loc[1]
	if item_id == null:
		item_id = 0
	var slot_type = 0
	if area != null:
		slot_type = Globals.gPlayer.INV.Areas[area].Slots[item_id].slot_type
		print(slot_type)
	#var item_slot_type = ItemDB.Items[_holding]["slot"]
	var item_slot_type = ItemDB.get_property_of_index(_holding,"slot_flags")
	if slot_type == 0:
		item_slot_type = [0]
	print("drop",item_id)
	if item_id == _index_from and area == _area_from or slot_type not in item_slot_type:
		Globals.gPlayer.INV.set_item(_area_from,_index_from, _holding)
		Globals.gPlayer.INV.set_active(_area_from,_index_from)
		clear_texture()
		reset()
	elif item_id != null and area != null:
		var item_2 = Globals.gPlayer.INV.set_item(area,item_id, _holding)
		Globals.gPlayer.INV.set_item(_area_from,_index_from, item_2)
		Globals.gPlayer.INV.set_active(area,item_id)
		clear_texture()
		reset()
	else:
		Globals.gPlayer.INV.set_item(_area_from,_index_from, _holding)
		Globals.gPlayer.INV.set_active(_area_from,_index_from)
		clear_texture()
		reset()
	

func reset():
	_area_from = null
	_index_from = null
	_holding = null
	_is_holding = false

func clear_texture():
	self.texture = null
