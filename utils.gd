extends Node


var scale = 10.0


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
	return val * scale
