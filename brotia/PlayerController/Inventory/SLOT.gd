extends TextureRect
class_name SLOT

var Item_id
@export var slot_type:String
@export var TEXTURE:TextureRect
@onready var COLOR:ColorRect = %ColorRect
var active = false

func set_active(state:bool):
	active = state
	%active_overlay.visible = active

func update(item_id):
	if item_id == null:
		item_id = 0
	var texture_path = "res://ITEM/icons/ERROR_icon.png"
	if ItemDB.Items[item_id]["icon"]:
		texture_path = ItemDB.Items[item_id]["icon"]
	var image = Image.new()
	image.load(texture_path)
	var image_texture = ImageTexture.new()
	image_texture.set_image(image)
		
	TEXTURE.texture = image_texture
	if COLOR:
		COLOR.color = ItemDB.Items[item_id]["color"]
	Item_id = item_id
