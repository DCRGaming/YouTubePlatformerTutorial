extends KinematicBody2D

class_name Player

onready var animation_state = $AnimationTree.get("parameters/playback")
onready var raycast = $RayCast2D #Used to check if player is on top of box
								 #don't transition to push state if on box

export(int) var gravity = 1000
export(int) var jump_speed = -300
export(int) var walk_speed: int = 75
export(int) var dash_speed: int = 300
export(int) var num_dashes: int = 1

var rigid_push: Vector2 = Vector2(225, 0)

# Handle slopes
var snap_length: int = 2
var snap_direction: Vector2 = Vector2.DOWN
var snap_vector = snap_direction * snap_length
var floor_max_angle = deg2rad(65)

var velocity: Vector2
var direction = "right"
var is_attacking = false
var is_dashing = false

var state
enum states {
	IDLE,
	WALK,
	FALL
	JUMP,
	ATTACK,
	DASH
}

### Mobile Controls
var button_path: String = "PlayerControlsJoystick/ButtonArea/Button"
onready var joystick = get_parent().get_parent().get_node(button_path)


func is_mobile_platform() -> bool:
	var os_name = OS.get_name()
#	os_name = "Android"
	if os_name == "Android" or os_name == "iOS":
		return true
	else:
		return false
		
func handle_mobile_input(action) -> float:
	if action == "ui_right":
		return 1.0
	elif action == "ui_left":
		return -1.0
	else:
		return 0.0


func _ready() -> void:
	state = states.IDLE
	get_node("HitboxPosition/Hitbox/CollisionShape2D").disabled = true
	
	
func update_direction(input_direction_x) -> void:
	if input_direction_x > 0:
		set_direction_right()
	elif input_direction_x < 0:
		set_direction_left()


func set_direction_right() -> void:
	direction = "right"
	$Sprite.flip_h = false
	$HitboxPosition.rotation_degrees = 0


func set_direction_left() -> void:
	direction = "left"
	$Sprite.flip_h = true
	$HitboxPosition.rotation_degrees = 180
	

func apply_gravity(delta) -> void:
	velocity.y += gravity * delta


func on_attack_finished():
	is_attacking = false


func on_dash_finished():
	is_dashing = false
	

# Replenish player dash count	
func reset_dash_counter(value) -> void:
	num_dashes = value


# Check if player ran out of dashes
func has_dashes() -> bool:
	if num_dashes > 0:
		return true
	return false


func play_death_sound() -> void:
	SoundManager.death_sound.play()


# handle in future tutorial
func restart_level() -> void:
	var current_level = get_parent().get_parent().name
	var path = "res://Scenes/Levels/" + current_level + ".tscn"
	var current_scene = load(path)
	SceneManager.change_scene(current_scene, "RestartLevelFade")
