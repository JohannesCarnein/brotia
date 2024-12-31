extends GridContainer

@export var space = 50
var Icon_Base = preload("res://PlayerController/Inventory/inv_icon.tscn")
var content:Array = []
var Slots = []
@onready var INV:INVENTORY = $"../../../../.."

func _ready() -> void:
	for i in space:
		content.append(null)
	init(content)

func init(content):
	self.columns = floor(size.x/64.0)
	print(self.columns)
	for item in content:
		var Icon = Icon_Base.instantiate()
		Icon.scale = Vector2(2,2)
		Icon.update(item)
		self.add_child(Icon)
		Slots.append(Icon)
	INV.items_changed.connect(update_icon)

func update_icon(id, item):
	content[id] = item
	Slots[id].update(item)
