extends Area2D
class_name PICKUP_AREA

var items_to_pickup : Array

func pickup(item, ITEM_ID, slot_id):
	#if self.get_parent().MAINHAND.Item == null:
		#self.get_parent().MAINHAND.change_item(ITEM_ID)
		#print("pickup main",ITEM_ID)
	if self.get_parent().INV.space >= ITEM_ID:
		var result = self.get_parent().INV.set_item(0,slot_id, ITEM_ID)
		if result == null:
			item.destroy()
		

func _on_area_entered(area: Area2D) -> void:
	if "pickup" in area.name.to_lower():
		var item = area.get_parent()
		var ITEM_ID = item.Item_ID
		var space_req = 1#ItemDB.Items[ITEM_ID]["space_req"]
		var slot_id = self.get_parent().INV.check_space(space_req)
		if slot_id >= 0:
			pickup(item, ITEM_ID, slot_id)
