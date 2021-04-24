extends Control


onready var sidebar = $Sidebar
onready var page_container = $PageLayoutArea/PageContainer
onready var ad_container = $PageLayoutArea/AdContainer
onready var page_layout_area = $PageLayoutArea
onready var ad_row_container = $Sidebar/VBoxContainer/MarginContainer4/AdRowContainer

var Page = preload("res://Page.tscn")
var AdRect = preload("res://AdRect.tscn")
var AdRow = preload("res://AdRow.tscn")

var sidebar_width: int
const padding = 16
var current_page_pos = Vector2()
var mouse_offset = Vector2.ZERO

var is_dragging = false
var holding_item = null

const MIN_ZOOM = 0.5
const MAX_ZOOM = 1.1
const PAGE_DEF = {
	"columns": 6,
	"column_width": 1.5856,
	"column_height": 20.1,
	"gutter_width": 0.0972,
	"page_height": 20.25,
	"margin_top": 0.5,
	"margin_bottom": 0.5,
	"margin_left": 0.375,
	"margin_right": 0.375
}


func _ready():
	sidebar_width = sidebar.rect_size.x
	current_page_pos.x = sidebar_width + padding
	current_page_pos.y = padding
	add_row_to_ad_rows({"ad_number": "123456", "columns": 1, "height": 3})
	add_row_to_ad_rows({"ad_number": "412334", "columns": 2, "height": 4.0})
	add_row_to_ad_rows({"ad_number": "456231", "columns": 3, "height": 10.0})
	add_row_to_ad_rows({"ad_number": "123452", "columns": 4, "height": 15})
	add_row_to_ad_rows({"ad_number": "412335", "columns": 5, "height": 18})
	add_row_to_ad_rows({"ad_number": "452212", "columns": 6, "height": 20.1})


func add_row_to_ad_rows(data):
	var new_row = AdRow.instance()
	ad_row_container.add_child(new_row)
	new_row.find_node("PlaceButton").connect("pressed", self, "_on_place_clicked", [new_row])
	new_row.setup(data)


func create_ad(data):
	var new_ad = AdRect.instance()
	new_ad.rect_position.x = 300
	new_ad.rect_position.y = 100
	new_ad.setup(data, PAGE_DEF)
	new_ad.connect("ad_clicked", self, "_on_ad_clicked")
	ad_container.add_child(new_ad)


func _on_ad_clicked(target, offset):
	mouse_offset = offset
	
	if is_dragging:
		is_dragging = false
		holding_item = null
		mouse_offset = Vector2.ZERO
	else:
		is_dragging = true
		target.rect_position = get_global_mouse_position() - mouse_offset
		holding_item = target


func _on_place_clicked(row):
	var data = row.get_data()
	create_ad(data)
	

func update_zoom():
	page_layout_area.scale.x = Utils.scale
	page_layout_area.scale.y = Utils.scale


func update_page_zoom():
	var cur_x = null
	
	for child in page_container.get_children():
		if cur_x == null:
			cur_x = child.rect_position.x
		
		child.rect_scale.x = Utils.scale
		child.rect_scale.y = Utils.scale
		child.rect_position.x = cur_x
		
		cur_x += child.rect_size.x * child.rect_scale.x
		cur_x += padding
	
	for ad_child in ad_container.get_children():
		ad_child.rect_scale.x = Utils.scale
		ad_child.rect_scale.y = Utils.scale


func _on_Button_pressed():
	var p = Page.instance()
	p.rect_position.x = current_page_pos.x
	p.rect_position.y = current_page_pos.y
	p.rect_scale.x = Utils.scale
	p.rect_scale.y = Utils.scale
	
	current_page_pos.x += p.rect_size.x * p.rect_scale.x
	current_page_pos.x += padding
	
	page_container.add_child(p)


func _on_ZoomInButton_pressed():
	Utils.zoom_in()
	update_zoom()


func _on_ZoomOutButton2_pressed():
	Utils.zoom_out()
	update_zoom()


func _on_AddAdButton_pressed():
	var new_ad = AdRect.instance()
	new_ad.rect_position.x = 300
	new_ad.rect_position.y = 100
	
	new_ad.connect("ad_clicked", self, "_on_ad_clicked", [new_ad])
	
	ad_container.add_child(new_ad)


func _input(event):
	if is_dragging:
		holding_item.rect_position = get_global_mouse_position() - mouse_offset

