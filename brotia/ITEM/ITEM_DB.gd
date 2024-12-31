extends Node
var Items=[]
var items_path = "C:/Users/johan/Documents/Godot_4_Third_Person_Controller/brotia/brotia/ITEM/RESOURCES/"

func _ready() -> void:
	var files = DirAccess.get_files_at(items_path)
	for file in files:
		if file.ends_with(".tres"):
			var resource = ResourceLoader.load(items_path+file)
			Items.append(resource)
			Items.sort_custom(sort_id)
			print(resource.slot_flags)

func sort_id(a, b):
	if a.ID < b.ID:
		return true
	return false


func get_property_of_index(index:int,property_name:String):
	var property = Items[index][property_name]
	return property

"""
const Items = [
	{
	"name":"Empty",
	"icon":"res://ITEM/icons/Empty_icon.png",
	"space_req":1,
	"color":Color(1.0,0.0,0.0,1.0),
	"description":"nix",
	"slot":"default"
	},
	{
	"name":"stick",
	"icon":"res://ITEM/icons/stick_icon.png",
	"space_req":1,
	"color":Color(0.1,1.0,0.1,1.0),
	"description":"cooler Stock",
	"slot":"Hand"
	},
	{
	"name":"potato",
	"icon":"res://ITEM/icons/potato_icon.png",
	"space_req":1,
	"color":Color(1.0,0.1,0.5,1.0),
	"description":"Energie für den Weg und im Notfall ein Wurfgeschoss",
	"slot":"Hand"
	},
	{
	"name":"Rüstung",
	"icon":"res://ITEM/icons/Breastplate_icon.png",
	"space_req":1,
	"color":Color(1.0,0.8,0.0,1.0),
	"description":"hiermit fühl ich mich sicher",
	"slot":"Chest"
	},
	{
	"name":"helm",
	"icon":"res://ITEM/icons/helm_01_icon.png",
	"space_req":1,
	"color":Color(1.0,0.8,0.0,1.0),
	"description":"klonk",
	"slot":"Head"
	}
	]
	"""
