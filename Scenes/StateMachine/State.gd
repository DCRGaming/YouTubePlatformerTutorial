extends Node

class_name State
# Step 1
# Virtual base class used for all your states.  The methods below are virtual
# methods, meaning we will override them in ourstate nodes (idle, walk, fall, etc.)

# We store a reference to the state machine so that we can call its "transition_to()" method directly
var state_machine = null


# Virtual function. Receives events from the `_unhandled_input()` callback in StateMachine.
func handle_input(_event: InputEvent) -> void:
	pass
	
	
# Virtual function. Corresponds to the `_process()` callback in StateMachine.
func update(_delta: float) -> void:
	pass
	
	
# Virtual function. Corresponds to the `_physics_process()` callback in StateMachine.
func physics_update(_delta: float) -> void:
	pass
	
	
# Called by the state machine upon changing the active state.  The "msg" parameter 
# is a dictionary with arbitrary data that the state can use to initialize itself.
# I removed the msg parameter for this game, see GDQuest link for his implementation
func enter() -> void:
	pass


# Called by the state machine before changing the active state.  Use this function
# to clean up the state.
func exit() -> void:
	pass
