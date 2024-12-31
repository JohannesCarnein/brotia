extends Resource
class_name ITEM_RESOURCE

enum SlotType {
	GENERIC,
	POTION,
	FOOD,
	CURRENCY,
	CRAFTING,
	E_MAINHAND,
	E_OFFHAND,
	E_HELMET,
	E_CHEST,
	E_BELT,
	E_HANDS,
	E_FEET,
	E_RING,
	E_NECK,
}

@export var ID:int = 0
@export var name := ""
@export_multiline var description := ""
@export var max_stack_count := 1
@export var texture : Texture
@export var functionality : PackedScene
@export var slot_flags : Array[SlotType] = [SlotType.GENERIC]
