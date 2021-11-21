extends Node

class_name StateMachine
# Step 4
# Generic state machine.  Initializes states and delegates engine callbacks
# (_physics_process, _unhandled_input, etc.) to the active state (idle, walk, etc.)

# Emitted when transitioning to a new state occurs.
# FYI, this signal is not used in this game and can be deleted
signal transitioned(state_name)

# Path to the state node such as Idle, Fall, etc.
export var initial_state := NodePath()

# set state to initial_state
onready var state: State = get_node(initial_state)


func _ready() -> void:
	# owner is the node owner which refers to Player
	# We need to wait until the owner (Player) is ready, because the state.enter()
	# will be called and this will likely throw an error because i.e. Fall will use
	# a property from Player that is not ready/fully loaded yet such as animation_state
	# So we use yield wait until Player is ready
	yield(owner, "ready")
	# StateMachine assigns itself to the State's state_machine property
	# i.e. Idle has a state_machine property from State, state_machine now refers to StateMachine
	for child in get_children():
		child.state_machine = self
	state.enter()


# The state machine subscribes to node callbacks and delegates them to the various 
# state objects (i.e. idle, fall, etc).
func _unhandled_input(event: InputEvent) -> void:
	state.handle_input(event)


func _process(delta: float) -> void:
	state.update(delta)


func _physics_process(delta: float) -> void:
	state.physics_update(delta)


# Handle transitioning to new state. There is an option to pass in msg, but I
# removed it.  See GDquest
func transition_to(target_state_name: String) -> void:
	# if there is no new state, return so there is no transition
	if not has_node(target_state_name):
		return

	# if there is new state, then exit current state and go to new state.
	state.exit()
	state = get_node(target_state_name)
	state.enter()
	emit_signal("transitioned", state.name)
