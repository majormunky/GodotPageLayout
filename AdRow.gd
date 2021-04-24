extends Control

onready var ad_number_label = $AdNumberLabel
onready var size_label = $SizeLabel

var ad_number
var columns
var height


func setup(data):
	ad_number = data["ad_number"]
	columns = data["columns"]
	height = data["height"]
	update_labels()


func update_labels():
	ad_number_label.text = ad_number
	size_label.text = String(columns) + "x" + String(height) + '"'
