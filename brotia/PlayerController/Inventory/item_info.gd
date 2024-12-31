extends BoxContainer

@export var signal_name:String
@export var Inventory:INVENTORY
@export var TEXTURE:TextureRect
@export var TEXT:TextEdit

func _ready() -> void:
	connect_signal_by_name(Inventory, signal_name)
	
func connect_signal_by_name(Inventory, signal_name):
	var function:Callable = Callable(self,"update")
	if Inventory.has_signal(signal_name):
		Inventory.connect(signal_name, function)
		print("Connected signal: ", signal_name)
	else:
		print("Signal not found: ", signal_name)
	
func update(item_id):
	#var item_id = Inventory.content[index]
	if item_id == null:
		item_id = 0
	#var texture_path = "res://ITEM/icons/ERROR_icon.png"
	#if ItemDB.Items[item_id]["icon"]:
	#	texture_path = ItemDB.Items[item_id]["icon"]
	#var image = Image.new()
	#image.load(texture_path)
	#var image_texture = ImageTexture.new()
	#image_texture.set_image(image)
	var image_texture = ItemDB.get_property_of_index(item_id,"texture")
	TEXTURE.texture = image_texture
	var slot_id = ItemDB.Items[item_id]["slot_flags"]
	TEXT.text = str(slot_id)+ItemDB.Items[item_id]["description"]
