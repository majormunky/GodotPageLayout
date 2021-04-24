extends Node


var scale = 1.0
var ppi = 10
const MIN_ZOOM = 0.5
const MAX_ZOOM = 2.0

# 30 pixels per inch
# get width of 1 column ad
# columns_to_inches(1, page_def) -> 1.5856
# from_inch(1.5856) -> 



func columns_to_inches(col, page_def):
	if col == 1:
		return page_def["column_width"]
	else:
		var result = 0
		result += (page_def["column_width"] * col)
		result += (page_def["gutter_width"] * (col - 1))
		return stepify(result, 0.01)



func to_inch(val):
	return val / scale


func from_inch(val):
	return val * scale * ppi


func zoom_in():
	scale += 0.05
	if scale > MAX_ZOOM:
		scale = MAX_ZOOM


func zoom_out():
	scale -= 0.05
	if scale < MIN_ZOOM:
		scale = MIN_ZOOM
