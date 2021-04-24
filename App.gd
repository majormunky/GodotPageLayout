extends Control


onready var sidebar = $Sidebar
onready var page_container = $PageContainer
onready var ad_container = $AdContainer
onready var ad_row_container = $Sidebar/VBoxContainer/MarginContainer4/AdRowContainer

var Page = preload("res://Page.tscn")
var AdRect = preload("res://AdRect.tscn")
var AdRow = preload("res://AdRow.tscn")

var sidebar_width: int
const padding = 16
var current_page_pos = Vector2()
var scale = 0.75
var is_dragging = false
var holding_item = null

const MIN_ZOOM = 0.5
const MAX_ZOOM = 1.1


func _ready():
	sidebar_width = sidebar.rect_size.x
	current_page_pos.x = sidebar_width + padding
	current_page_pos.y = padding
	add_row_to_ad_rows({"ad_number": "123456", "size": "6x20"})
	add_row_to_ad_rows({"ad_number": "412334", "size": "3x10"})
	add_row_to_ad_rows({"ad_number": "456231", "size": "6x10"})


func add_row_to_ad_rows(data):
	var new_row = AdRow.instance()
	ad_row_container.add_child(new_row)
	new_row.find_node("PlaceButton").connect("pressed", self, "_on_place_clicked", [new_row])
	new_row.setup(data)


func _on_ad_clicked(target):
	if is_dragging:
		is_dragging = false
		holding_item = null
	else:
		is_dragging = true
		target.rect_position = get_global_mouse_position()
		holding_item = target


func _on_place_clicked(row):
	print("Place clicked", row)


func update_page_zoom():
	var cur_x = null
	
	for child in page_container.get_children():
		if cur_x == null:
			cur_x = child.rect_position.x
		
		child.rect_scale.x = scale
		child.rect_scale.y = scale
		child.rect_position.x = cur_x
		
		cur_x += child.rect_size.x * child.rect_scale.x
		cur_x += padding


func _on_Button_pressed():
	var p = Page.instance()
	p.rect_position.x = current_page_pos.x
	p.rect_position.y = current_page_pos.y
	p.rect_scale.x = scale
	p.rect_scale.y = scale
	
	current_page_pos.x += p.rect_size.x * p.rect_scale.x
	current_page_pos.x += padding
	
	page_container.add_child(p)


func _on_ZoomInButton_pressed():
	scale += 0.05
	if scale > MAX_ZOOM:
		scale = MAX_ZOOM
	print("Current Scale: ", scale)
	update_page_zoom()


func _on_ZoomOutButton2_pressed():
	scale -= 0.05
	if scale < MIN_ZOOM:
		scale = MIN_ZOOM
	print("Current Scale: ", scale)
	update_page_zoom()


func _on_AddAdButton_pressed():
	var new_ad = AdRect.instance()
	new_ad.rect_position.x = 300
	new_ad.rect_position.y = 100
	
	new_ad.connect("ad_clicked", self, "_on_ad_clicked", [new_ad])
	
	ad_container.add_child(new_ad)


func _input(event):
	if is_dragging:
		holding_item.rect_position = get_global_mouse_position()
		
		
