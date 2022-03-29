extends PlayerState


func enter() -> void:
	player.animation_state.travel("Walk")


func exit() -> void:
	pass
	
	

func physics_update(delta: float) -> void:

	if not player.is_on_floor():
		if player.velocity.y > 0:
			state_machine.transition_to("Fall")
			return

	var input_direction_x: float = (
		Input.get_action_strength("ui_right") 
		- Input.get_action_strength("ui_left")
	)

	# Keep left or keep right if left and right are pressed together
	if Input.is_action_pressed("ui_right") && \
		Input.is_action_pressed("ui_left"):
		if player.direction == "right":
			input_direction_x = 1
		else:
			input_direction_x = -1

### Mobile
	if player.is_mobile_platform():
		input_direction_x = player.handle_mobile_input(player.joystick.get_action())
### Mobile

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
			if collider is SpikeClub:
				state_machine.transition_to("Death")
				return
			elif collider is SpikePit:
				state_machine.transition_to("Death")
				return
			elif collider is Enemy:
				state_machine.transition_to("Death")
			elif collider is RigidBox:
				if player.raycast.is_colliding():
					if player.raycast.collide_with_bodies:
						var collider_ray = player.raycast.get_collider()
						# check you are not standing on box
						if not (collider_ray is RigidBox):
							state_machine.transition_to("Push")
				
	# handle other transitions
	if Input.is_action_just_pressed("jump"):
		state_machine.transition_to("Jump")
	elif is_equal_approx(input_direction_x, 0.0):
		state_machine.transition_to("Idle")
	elif Input.is_action_just_pressed("attack"):
		state_machine.transition_to("Attack")
	elif Input.is_action_just_pressed("dash") and player.has_dashes():
		state_machine.transition_to("Dash")
