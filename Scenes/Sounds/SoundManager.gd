extends Node2D

# Singleton

# Music
onready var music_list = $Music
onready var title_screen_music = $Music/TitleScreenMusic
onready var gameplay_music = $Music/GamePlayMusic
onready var ending_music = $Music/EndingMusic


# Sound Effects
onready var sound_effect_list = $SoundEffects
onready var attack_sound = $SoundEffects/AttackSound
onready var button_sound = $SoundEffects/ButtonSound
onready var dash_sound = $SoundEffects/DashSound
onready var death_sound = $SoundEffects/DeathSound
onready var jump_sound = $SoundEffects/JumpSound
onready var land_sound = $SoundEffects/LandSound
onready var level_complete_sound = $SoundEffects/LevelCompleteSound
onready var logo_sound = $SoundEffects/LogoSound

# Scroll bar properties
var music_scroll_vol_current = null
var sound_effect_scroll_vol_current = null
var previous_music_vol_incr = 0
var previous_sound_effect_vol_incr = 0

# Future episode on creating a sound setting screen to update music/sound effects
func update_sound_volume(value, vol_range, type):
	match type:
		"Music":
			for i in music_list.get_child_count():
				var music = music_list.get_child(i)
				music.volume_db += value - vol_range - previous_music_vol_incr
			previous_music_vol_incr = value - vol_range
			music_scroll_vol_current = value
		"SoundEffects":
			for i in sound_effect_list.get_child_count():
				var sound_effect = sound_effect_list.get_child(i)
				sound_effect.volume_db += value - vol_range - previous_sound_effect_vol_incr
			previous_sound_effect_vol_incr = value - vol_range
			sound_effect_scroll_vol_current = value


func stop_all_music():
	for i in music_list.get_child_count():
		var music = music_list.get_child(i)
		if music.playing:
			music.playing = false
