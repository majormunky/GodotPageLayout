extends ColorRect

onready var label = $Label
var ad_number = "n/a"
var columns = null
var height = null

signal ad_clicked(ad_rect)


# Called when the node enters the scene tree for the first time.
func _ready():
	label.text = ad_number


func setup(data):
	ad_number = data["ad_number"]
	columns = data["columns"]
	height = data["height"]


func _gui_input(event):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and event.pressed:
			print("I've been clicked D:")
			emit_signal("ad_clicked")


func get_drag_data(position):
	var data = {}
	return data
