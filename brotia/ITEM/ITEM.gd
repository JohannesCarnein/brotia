@tool
extends Node
class_name ITEM
signal pickup

@export var Item_ID: int:
	set(value):
		Item_ID = value
		update_image()
		update_space_required()
		
var space_required = 1
@onready var sprite:Sprite2D = %Sprite2D

func _ready() -> void:
	update_image()
	update_space_required()


func update_space_required():
	space_required = ItemDB.Items[Item_ID]["space_req"]
	
func update_image():
	if sprite:
		var texture_path = ItemDB.Items[Item_ID]["icon"]
		var image = Image.new()
		image.load(texture_path)
		var image_texture = ImageTexture.new()
		image_texture.set_image(image)
		print(sprite)
		sprite.texture = image_texture

func _pickup():
	pickup.emit()
	destroy()
	
func destroy():
	self.queue_free()
