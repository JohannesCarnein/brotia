@tool
extends Control

const TablesPluginSettingsClass := preload("res://addons/resources_spreadsheet_view/settings_grid.gd")

@export var table_header_scene : PackedScene

@onready var editor_view : Control = $"../../../.."
@onready var hide_columns_button : MenuButton = $"../../MenuStrip/VisibleCols"
@onready var grid : GridContainer = $"../../../MarginContainer/FooterContentSplit/Panel/Scroll/MarginContainer/TableGrid"


var column_properties := {}
var columns := []:
	set(v):
		columns = v
		for x in get_children():
			remove_child(x)
			x.queue_free()

		var new_node : Control
		for x in v:
			new_node = table_header_scene.instantiate()
			new_node.manager = self
			add_child(new_node)
			new_node.set_label(x)
			new_node.get_node("Button").pressed.connect(editor_view._set_sorting.bind(x))


func _ready():
	hide_columns_button\
		.get_popup()\
		.id_pressed\
		.connect(_on_visible_cols_id_pressed)
	$"../../../MarginContainer/FooterContentSplit/Panel/Scroll"\
		.get_h_scroll_bar()\
		.value_changed\
		.connect(_on_h_scroll_changed)


func update():
	_update_hidden_columns()
	_update_column_sizes()


func hide_column(column_index : int):
	set_column_property(column_index, &"visibility", 0)
	editor_view.save_data()
	update()


func set_column_property(column_index : int, property_key : StringName, property_value):
	var dict := column_properties
	if !dict.has(editor_view.current_path):
		dict[editor_view.current_path] = {}

	dict = dict[editor_view.current_path]	
	if !dict.has(columns[column_index]):
		dict[columns[column_index]] = {}

	dict = dict[columns[column_index]]
	dict[property_key] = property_value


func get_column_property(column_index : int, property_key : StringName, property_default = null):
	var dict := column_properties
	if !dict.has(editor_view.current_path):
		return property_default

	dict = dict[editor_view.current_path]	
	if !dict.has(columns[column_index]):
		return property_default

	dict = dict[columns[column_index]]
	return dict.get(property_key, property_default)


func select_column(column_index : int):
	editor_view.select_column(column_index)


func _update_column_sizes():
	if grid.get_child_count() == 0:
		return
		
	await get_tree().process_frame
	var column_headers := get_children()

	if grid.get_child_count() < column_headers.size(): return
	if column_headers.size() != columns.size():
		editor_view.refresh()
		return
	
	var clip_text : bool = ProjectSettings.get_setting(TablesPluginSettingsClass.PREFIX + "clip_headers")
	var min_width := 0
	var cell : Control

	for i in column_headers.size():
		var header = column_headers[i]
		cell = grid.get_child(i)

		header.get_child(0).clip_text = clip_text
		header.custom_minimum_size.x = 0
		cell.custom_minimum_size.x = 0
		header.size.x = 0

		min_width = max(header.size.x, cell.size.x)
		header.custom_minimum_size.x = min_width
		cell.custom_minimum_size.x = header.get_minimum_size().x
		header.size.x = min_width

	grid.hide()
	grid.show()
	hide()
	show()
	await get_tree().process_frame

	# Abort if the node has been deleted since.
	if !is_instance_valid(column_headers[0]):
		return

	get_parent().custom_minimum_size.y = column_headers[0].size.y
	for i in column_headers.size():
		column_headers[i].position.x = grid.get_child(i).position.x
		column_headers[i].size.x = grid.get_child(i).size.x


func _update_hidden_columns():
	var current_path : String = editor_view.current_path
	var rows_shown : int = editor_view.last_row - editor_view.first_row

	if !column_properties.has(current_path):
		column_properties[current_path] = {
			"resource_local_to_scene" : { &"visibility" : 0 },
			"resource_name" : { &"visibility" : 0 },
		}
		editor_view.save_data()

	var visible_column_count := 0
	for i in columns.size():
		var column_visible : bool = get_column_property(i, &"visibility", 1) != 0
		get_child(i).visible = column_visible
		for j in rows_shown:
			grid.get_child(j * columns.size() + i).visible = column_visible

		if column_visible:
			visible_column_count += 1

	grid.columns = visible_column_count


func _on_h_scroll_changed(value):
	position.x = -value


func _on_visible_cols_about_to_popup():
	var popup := hide_columns_button.get_popup()
	popup.clear()
	popup.hide_on_checkable_item_selection = false
	for i in columns.size():
		popup.add_check_item(columns[i].capitalize(), i)
		popup.set_item_checked(i, get_column_property(i, &"visibility", 1) != 0)


func _on_visible_cols_id_pressed(id : int):
	var popup := hide_columns_button.get_popup()
	if popup.is_item_checked(id):
		popup.set_item_checked(id, false)
		set_column_property(id, &"visibility", 0)

	else:
		popup.set_item_checked(id, true)
		set_column_property(id, &"visibility", 1)

	editor_view.save_data()
	update()