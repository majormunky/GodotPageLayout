extends Control


onready var sidebar = $Sidebar
onready var page_container = $PageLayoutArea/PageContainer
onready var ad_container = $PageLayoutArea/AdContainer
onready var page_layout_area = $PageLayoutArea
onready var ad_row_container = $Sidebar/VBoxContainer/MarginContainer4/AdRowContainer
onready var page_count_label = $Sidebar/VBoxContainer/MarginContainer5/VBoxContainer/PageCountLabel

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
	load_ads()


func get_ads_from_csv():
	var result = null
	var file = File.new()
	if file.file_exists("res://assets/data/ads.csv"):
		print("File exists")
		var open_file = file.open("res://assets/data/ads.csv", File.READ)
		if open_file == OK:
			result = file.get_as_text()
		file.close()
	else:
		print("File does not exist")
	return result


func text_to_rows(data):
	var result = []
	var parts = data.split("\n")
	var first = 0
	for row in parts:
		if first == 0:
			first += 1
			continue
		
		var row_parts = row.split(",")
		var row_data = {
			"ad_number": row_parts[0],
			"columns": int(row_parts[1]),
			"height": float(row_parts[2]),
		}
		result.append(row_data)
	return result


func load_ads():
	var csv_data = get_ads_from_csv()
	var rows = text_to_rows(csv_data)
	for row in rows:
		add_row_to_ad_rows(row)

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


func _on_AddPageButton_pressed():	
	var p = Page.instance()
	p.rect_position.x = current_page_pos.x
	p.rect_position.y = current_page_pos.y
	p.rect_scale.x = Utils.scale
	p.rect_scale.y = Utils.scale
	p.page_num = page_container.get_child_count() + 1
	
	current_page_pos.x += p.rect_size.x * p.rect_scale.x
	current_page_pos.x += padding
	
	page_container.add_child(p)
	
	update_page_count_label()


func update_page_count_label():
	page_count_label.text = "Pages: " + String(page_container.get_child_count())


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


func _input(_event):
	if is_dragging:
		holding_item.rect_position = get_global_mouse_position() - mouse_offset

