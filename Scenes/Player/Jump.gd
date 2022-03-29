extends PlayerState


func enter() -> void:
	player.velocity.y = player.jump_speed
	player.animation_state.travel("Jump")
	SoundManager.jump_sound.play()


func exit() -> void:
	pass
	
	

func physics_update(delta: float) -> void:
	
	if player.velocity.y > 0:
		state_machine.transition_to("Fall")
		return
		
	# Allows left-right movement when jumping.
	var input_direction_x: float = (
		Input.get_action_strength("ui_right") 
		- Input.get_action_strength("ui_left")
	)

### Mobile
	if player.is_mobile_platform():
		input_direction_x = player.handle_mobile_input(player.joystick.get_action())
### Mobile

	player.update_direction(input_direction_x)
	player.velocity.x = player.walk_speed * input_direction_x
	player.apply_gravity(delta)
	player.velocity = player.move_and_slide(player.velocity, Vector2.UP)
	
	# handle collisions in future tutorial
	if player.get_slide_count() > 0:
		for i in player.get_slide_count():
			var collision = player.get_slide_collision(i)
			var collider = collision.collider
			if collider is SpikeClub:
				state_machine.transition_to("Death")
				return
	
	# handle other transitions
	if Input.is_action_just_pressed("dash") and player.has_dashes():
		state_machine.transition_to("Dash")
