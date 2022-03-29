extends Node2D


# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print("parent position: ", self.get_position())
	print("parent global position: ", self.get_global_position())
	print("child position: ", $Child.get_position())
	print("child global position: ", $Child.get_global_position())
