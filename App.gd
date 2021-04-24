extends Control


onready var sidebar = $Sidebar
onready var page_container = $PageContainer

var Page = preload("res://Page.tscn")
var sidebar_width: int
const padding = 16
var current_page_pos = Vector2()
var scale = 0.75


func _ready():
	sidebar_width = sidebar.rect_size.x
	current_page_pos.x = sidebar_width + padding
	current_page_pos.y = padding


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
	update_page_zoom()


func _on_ZoomOutButton2_pressed():
	pass # Replace with function body.
