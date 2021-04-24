extends ColorRect

onready var label = $Label
var ad_number = "n/a"
var columns = null
var height = null
var inches_wide = null
var page_def = null

signal ad_clicked(ad_rect, mouse_offset)


# Called when the node enters the scene tree for the first time.
func _ready():
	label.text = ad_number


func setup(data, _page_def):
	ad_number = data["ad_number"]
	columns = data["columns"]
	height = data["height"]
	page_def = _page_def
	inches_wide = Utils.columns_to_inches(columns, page_def)
	update_size()
	

func update_size():
	var px = Utils.from_inch(inches_wide)
	var py = Utils.from_inch(height)
	self.rect_size.x = px
	self.rect_size.y = py


func _gui_input(event):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and event.pressed:
			print(event.position)
			var mouse_pos = event.position - Vector2(1, 1)
			emit_signal("ad_clicked", self, mouse_pos)


func get_drag_data(_position):
	var data = {}
	return data
