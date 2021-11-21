extends StaticBody2D

onready var animated_sprite: AnimatedSprite = $AnimatedSprite
onready var collision_shape: CollisionShape2D = $CollisionShape2D


var state
var is_closed: bool = true
var state_queue = []
#c = closed, o = open, c, o, c, o, c, o

enum states {
	IDLE,
	CLOSE,
	OPEN
}

func _ready() -> void:
	state = states.IDLE


func _process(delta: float) -> void:
	match state:
		states.IDLE:
			animated_sprite.play("Idle")
		states.CLOSE:
			# Idle state is technically closed, you don't want to close when in IDLE
			if not is_closed:
				collision_shape.disabled = false
				animated_sprite.play("Close")
				yield(animated_sprite, "animation_finished")
				is_closed = true
		states.OPEN:
			if is_closed:
				animated_sprite.play("Open")
				yield(animated_sprite, "animation_finished")
				collision_shape.disabled = true
				is_closed = false
				
	if state_queue.size() > 0:
		# the next state is the last element/state in the array.
		var next_state = state_queue.back()
		# Nothing to do cause current state is equal to next state
		if state == next_state:
			return
		if next_state == states.CLOSE:
			# Nothing to do cause idle state is technically also close state
			if state == states.IDLE:
				state_queue.clear()
				return
			# If you are open, then go to close state
			if state == states.OPEN:
				state = states.CLOSE
				state_queue.clear()
				return
		# if you are idle or close, then go to open state
		if next_state == states.OPEN:
			state = states.OPEN
			state_queue.clear()


func close_stone_gate():
	state_queue.append(states.CLOSE)


func open_stone_gate():
	state_queue.append(states.OPEN)


func _on_AnimatedSprite_animation_finished() -> void:
	if state == states.CLOSE:
		state = states.IDLE
