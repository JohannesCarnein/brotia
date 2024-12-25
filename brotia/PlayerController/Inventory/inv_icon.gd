extends Control
class_name INV_ICON
@export var TEXTURE:TextureRect
@onready var COLOR:ColorRect = %ColorRect

func update(item_id):
	if item_id == null:
		item_id = 0
	var texture_path = ItemDB.Items[item_id]["icon"]
	var image = Image.new()
	image.load(texture_path)
	var image_texture = ImageTexture.new()
	image_texture.set_image(image)
	print(image)
		
	TEXTURE.texture = image_texture
	#COLOR.color = Color(randf(),randf(),randf())
	
