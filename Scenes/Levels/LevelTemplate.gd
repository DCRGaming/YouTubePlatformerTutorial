extends Node2D

# Icons need to be 512x512
var icon_number = 1

# Feature Image needs to be 1024x500
var feature_number = 1

# Screen shots need to be 16:9 or 9:16 ratio and minimum 320px in length
var screenshot_number = 1

func _ready() -> void:
	pass # Replace with function body.



func _on_Timer_timeout() -> void:
	var icon_path = "res://Screenshots/icon" + str(icon_number) + ".png"
	var feature_graphic_path = "res://Screenshots/feature" + str(feature_number) + ".png"
	var screenshot_path = "res://Screenshots/screenshot" + str(screenshot_number) + ".png"
	
	var image = get_tree().get_root().get_texture().get_data()
	# Image will be upside down, so we flip it vertically
	image.flip_y()
	
#	image.save_png(icon_path)
#	image.save_png(feature_graphic_path)
	image.save_png(screenshot_path)
	
	icon_number += 1
	feature_number += 1 
	screenshot_number += 1
