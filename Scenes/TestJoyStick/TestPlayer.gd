extends KinematicBody2D


onready var joystick = get_parent().get_node("ButtonArea/Button")
var input_direction = 0
var speed = 25

func _ready() -> void:
	pass # Replace with function body.

func _physics_process(delta: float) -> void:
	move_and_slide(joystick.get_direction() * speed)
