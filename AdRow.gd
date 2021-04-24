extends Control

onready var ad_number_label = $AdNumberLabel
onready var size_label = $SizeLabel

var ad_number
var size


func setup(data):
	ad_number = data["ad_number"]
	size = data["size"]
	update_labels()


func update_labels():
	ad_number_label.text = ad_number
	size_label.text = size
