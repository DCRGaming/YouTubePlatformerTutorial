extends KinematicBody2D

# Coordinate system
# +x = right
# -x = left
# +y = down
# -y = up

# Definitions
# Speed  		= a number/magnitude/value, without direction, distance/time, 
#				  i.e. ft/s, m/s
# Vector 		= a number/magnitude/value, with a direction
# Velocity 		= a number/magnitude/value, with a direction, a vector,
#				  describes how position is changing, distance/time, ft/s, m/s
# Acceleration 	= a number/magnitude/value, with a direction, a vector,
#				  describes how velocity is changing, distance/time^2, ft/s^2,
#			      m/s^2

class_name Enemy

var snap_length: int = 2
var snap_direction: Vector2 = Vector2.DOWN
var snap_vector = snap_direction * snap_length
var floor_max_angle = deg2rad(65)

export(float) var gravity = 1000 # acceleration
export(int) var walk_speed = 75 # speed

var velocity: Vector2 # (x, y)
var direction: String = "right" # enemy is facing which way?
var state

var rng = RandomNumberGenerator.new() # creates a new node of this class
var input_direction_x # actual direction in code

enum states {
	WALK,
	DEATH
} # constants

# runs once all nodes load into the scene
func _ready() -> void:
	rng.randomize() # time based seed given to generator
	input_direction_x = 1
	state = states.WALK
	# get_node("MoveTimer")
	$MoveTimer.start()
	

func get_random_direction() -> int:
	# Random integer is either 0 or 1
	var random_number = rng.randi_range(0, 1)
	# Return either -1 or 1 depending on random number
	return [-1, 1][random_number]
	

func set_direction_right() ->void:
	direction = "right"
	$AnimatedSprite.flip_h = false
	

func set_direction_left() -> void:
	direction = "left"
	$AnimatedSprite.flip_h = true
	
	
func update_direction(direction_x) -> void:
	if direction_x > 0 :
		set_direction_right()
	elif direction_x < 0:
		set_direction_left()
	

# delta is time, the amount of time from between the previouse frame to current frame
func _physics_process(delta: float) -> void:
	
	match state:
		states.WALK:
			$AnimatedSprite.play("Walk")
			update_direction(input_direction_x)
			velocity.x = walk_speed * input_direction_x # ft/s
			apply_gravity(delta)
			# velocity = (ft/s, ft/s^2) no delta
			# velocity = (ft/s, ft/s) with delta
#			velocity = move_and_slide(velocity, Vector2.UP)
			velocity = move_and_slide_with_snap(velocity, 
														snap_vector, 
														Vector2.UP, 
														true, 
														4, 
														floor_max_angle,
														false)
			# handle collisions in future tutorial
			# check for array of collisions
			if get_slide_count() > 0:
				for i in get_slide_count():
					var collision = get_slide_collision(i)
					var collider = collision.collider
					if collider is Player:
						collider.get_node("StateMachine").transition_to("Death")
					
		states.DEATH:
			$AnimatedSprite.play("Death")
			$CollisionShape2D.disabled = true
			yield($AnimatedSprite, "animation_finished")
			queue_free()
	
	
func apply_gravity(delta) -> void:
	# velocity.y = velocity.y + gravity * delta
	velocity.y += gravity * delta # no delta, velocity.y = gravity, units = ft/s^2, with delta -> gravity = ft/s
	

func _on_MoveTimer_timeout() -> void:
	input_direction_x = get_random_direction()
	

func _on_Hurtbox_area_entered(area: Area2D) -> void:
	
	# check that area (attack) is actually the player
	if area.owner is Player:
		state = states.DEATH
