extends Control

export var level_scene: PackedScene
export var settings_scene: PackedScene


func _ready() -> void:
	if not SoundManager.title_screen_music.playing:
		SoundManager.title_screen_music.play()



func _on_StartButton_button_up() -> void:
	SoundManager.stop_all_music()
	SceneManager.change_scene(level_scene, "DarkFade")
	SoundManager.gameplay_music.play()


func _on_StartButton_button_down() -> void:
	SoundManager.button_sound.play()


func _on_SettingsButton_button_up() -> void:
	SceneManager.change_scene(settings_scene)


func _on_SettingsButton_button_down() -> void:
	SoundManager.button_sound.play()
