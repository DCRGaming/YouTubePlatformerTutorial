extends Control

# Loop back to logo screen since this is the end of the game
var next_scene: PackedScene = SceneManager.LogoScreen

# Counter used to keep track of which credit text we are on
var counter = 0

# Background scrolling speed
var scroll_speed: int = 10

var credit_list = [
	["Game Director", "DCR",],
	["Programming", "DCR"],
	["Art", "https://o-lobster.itch.io/"],
	["Animation", "https://o-lobster.itch.io/"],
	["Level Design", "DCR"],
	["Music", "Matthew Pablo \n (http://www.matthewpablo.com)" ],
	["Sound Effects", "Jalastram \n Jesus Lastra \n Virix David McKee \n NenadSimic \n qubodup \n Lamoot \n Macro"],
	["Font", "Kenney Pixel"],
	["Programs", "Krita \n Godot"],
	["Thank You!", "DCR"]
]

func _ready() -> void:
	SoundManager.stop_all_music()
	SoundManager.ending_music.play()
	$Timer.start()


func _process(delta: float) -> void:
	$ParallaxBackground/ParallaxLayer.motion_offset.x -= scroll_speed * delta


func _on_Timer_timeout() -> void:
	# 0 grabs the zero'th element in the array (Title)
	# 1 grabs the one'th element in the array (Name)
	$VBoxContainer/Title.text = credit_list[counter][0]
	$VBoxContainer/Name.text = credit_list[counter][1]
	$AnimationPlayer.play("FadeInNOut")
	counter += 1
	if counter == credit_list.size():
		$Timer.stop()
		SceneManager.change_scene(next_scene, "DarkFade")
