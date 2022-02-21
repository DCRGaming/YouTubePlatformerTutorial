extends CanvasLayer

# Keep track of what was the last animation played
var last_played_anim = null

# The fade screen colors used, a dark one and a light one
var color_dark = Color(56, 62, 96, 255) 
var color_light = Color(255, 255, 255, 255)

# The opening scene of the game
onready var LogoScreen = load("res://Scenes/UI/LogoScreen/LogoScreen.tscn")


func _ready() -> void:
	# Change to logo screen using a dark fade transition/animation
	change_scene(LogoScreen, "DarkFade")
	
	
func change_scene(new_scene, anim = null) -> void:
	if anim:
		reset_color_rect(anim)
		$AnimationPlayer.play(anim)
	get_tree().change_scene_to(new_scene)
	last_played_anim = anim


# return the animation duration
func get_anim_duration() -> float:
	if last_played_anim == null:
		return 0.0
	return $AnimationPlayer.get_animation(last_played_anim).length


# Need to reset ColorRect, because previous animation made it transparent.
func reset_color_rect(anim) -> void:
	match anim:
		"DarkFade":
			$ColorRect.color = color_dark
		"LightFade":
			$ColorRect.color = color_light
		"RestartLevelFade":
			$ColorRect.color = color_dark
