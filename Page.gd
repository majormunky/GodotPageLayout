extends ColorRect

var page_num = 0
onready var page_num_label = $PageNumContainer/PageNumLabel

func _ready():
	if page_num != null:
		page_num_label.text = String(page_num)

