extends PlayerState


func enter() -> void:
	player.is_attacking = true
	player.animation_state.travel("Attack")
	SoundManager.attack_sound.play()

func exit() -> void:
	pass
	
	

func physics_update(delta: float) -> void:
	if !player.is_attacking:
		state_machine.transition_to("Idle")
