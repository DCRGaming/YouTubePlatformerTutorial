extends Position2D

export var rotation_speed: int = 50
export var left: bool = false
export var up: bool = false
export var right: bool = false
export var down: bool = false

var starting_rotation
var ending_rotation
var direction: int = 1

func _ready() -> void:
	if left:
		starting_rotation = 0
		ending_rotation = 180
	elif up:
		starting_rotation = 90
		ending_rotation = 270
	elif right:
		starting_rotation = 180
		ending_rotation = 360
	elif down:
		starting_rotation = -90
		ending_rotation = 90	
	self.rotation_degrees = starting_rotation	


func _physics_process(delta: float) -> void:
	if self.rotation_degrees < starting_rotation:
		direction = 1
	elif self.rotation_degrees > ending_rotation:
		direction = -1	
	self.rotation_degrees += rotation_speed * direction * delta
