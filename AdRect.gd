extends ColorRect

onready var label = $Label
var ad_number = "n/a"
var columns = null
var height = null
var inches_wide = null
var page_def = null

signal ad_clicked(ad_rect)


# Called when the node enters the scene tree for the first time.
func _ready():
	label.text = ad_number


func setup(data, _page_def):
	ad_number = data["ad_number"]
	columns = data["columns"]
	height = data["height"]
	page_def = _page_def
	inches_wide = Utils.columns_to_inches(columns, page_def)


func _gui_input(event):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and event.pressed:
			print("I've been clicked D:")
			emit_signal("ad_clicked")


func get_drag_data(position):
	var data = {}
	return data
