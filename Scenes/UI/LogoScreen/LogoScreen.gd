extends TextureRect


export var next_scene: PackedScene
var duration: int = 1


func _ready() -> void:
	SoundManager.stop_all_music() # When game loops back from ending to beginning, stop all music
	SoundManager.logo_sound.play()
	# wait time = Screen transition/animation time + remaining logo screen time
	$Timer.wait_time = SceneManager.get_anim_duration() + duration
	$Timer.start()


func _on_Timer_timeout() -> void:
	SceneManager.change_scene(next_scene)
