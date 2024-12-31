extends TextureRect
class_name SLOT

var Item_id
@export var slot_type:ITEM_RESOURCE.SlotType
@export var TEXTURE:TextureRect
@export var _signal:String
var active = false

func set_active(state:bool):
	active = state
	%active_overlay.visible = active

func update(item_id):
	if item_id == null:
		item_id = 0
	var image_texture = ItemDB.get_property_of_index(item_id,"texture")
	TEXTURE.texture = image_texture
	Item_id = item_id
	Globals.gPlayer.INV.emit_signal(_signal, item_id)
