extends Control

var next_scene: String = "res://Scenes/UI/TitleScreen/TitleScreen.tscn"
var music_vol_range: float
var sound_effect_vol_range: float
onready var music_scrollbar: HScrollBar = $VBoxContainer/MusicScrollBar
onready var sound_effect_scrollbar: HScrollBar = $VBoxContainer/SoundEffectsScrollBar



func _ready() -> void:
	music_vol_range = get_scrollbar_range_value(music_scrollbar.min_value, music_scrollbar.max_value)
	sound_effect_vol_range = get_scrollbar_range_value(sound_effect_scrollbar.min_value, sound_effect_scrollbar.max_value)
	if not SoundManager.title_screen_music.playing:
		SoundManager.title_screen_music.play()
	# We do not want the volume to reset everytime we leave and
	# enter the settings screen.  So we check if there is a current value and set it
	if SoundManager.music_scroll_vol_current != null:
		music_scrollbar.value = SoundManager.music_scroll_vol_current
	if SoundManager.sound_effect_scroll_vol_current != null:
		sound_effect_scrollbar.value = SoundManager.sound_effect_scroll_vol_current


func get_scrollbar_range_value(min_value, max_value) -> float:
	return (max_value - min_value)/2


func _on_Button_button_up() -> void:
	get_tree().change_scene(next_scene)


func _on_Button_button_down() -> void:
	SoundManager.button_sound.play()


func _on_MusicScrollBar_scrolling() -> void:
	SoundManager.update_sound_volume(music_scrollbar.value, music_vol_range, "Music")


func _on_SoundEffectsScrollBar_scrolling() -> void:
	SoundManager.update_sound_volume(sound_effect_scrollbar.value, sound_effect_vol_range, "SoundEffects")
