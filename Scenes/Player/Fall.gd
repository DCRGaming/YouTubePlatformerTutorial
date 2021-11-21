extends PlayerState


func enter() -> void:
	player.animation_state.travel("Fall")


func exit() -> void:
	pass
	
	

func physics_update(delta: float) -> void:
	
	if player.is_on_floor():
		state_machine.transition_to("Idle")
		return

	# Allows left-right movement when falling.
	var input_direction_x: float = (
		Input.get_action_strength("ui_right") 
		- Input.get_action_strength("ui_left")
	)
	
	player.update_direction(input_direction_x)
	player.velocity.x = player.walk_speed * input_direction_x
	player.apply_gravity(delta)
#	player.velocity = player.move_and_slide(player.velocity, Vector2.UP)
	player.velocity = player.move_and_slide_with_snap(player.velocity, 
														player.snap_vector, 
														Vector2.UP, 
														true, 
														4, 
														player.floor_max_angle,
														false)
	
	# handle collisions in future tutorial
	if player.get_slide_count() > 0:
		for i in player.get_slide_count():
			var collision = player.get_slide_collision(i)
			var collider = collision.collider
			if collider is SpikePit:
				if collision.normal.y == -1:
					state_machine.transition_to("Death")
					return
			elif collider is SpikeClub:
				state_machine.transition_to("Death")
				return

	# handle other transitions
	if Input.is_action_just_pressed("dash") and player.has_dashes():
		state_machine.transition_to("Dash")
