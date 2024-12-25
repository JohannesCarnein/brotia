extends Area2D
class_name PICKUP_AREA

var items_to_pickup : Array

func pickup(ITEM_ID):
	#if self.get_parent().MAINHAND.Item == null:
		#self.get_parent().MAINHAND.change_item(ITEM_ID)
		#print("pickup main",ITEM_ID)
	if self.get_parent().INV.space >= ITEM_ID:
		self.get_parent().INV.set_item(ITEM_ID)

func _on_area_entered(area: Area2D) -> void:
	if "pickup" in area.name.to_lower():
		var item = area.get_parent()
		var ITEM_ID = item.Item_ID
		pickup(ITEM_ID)
