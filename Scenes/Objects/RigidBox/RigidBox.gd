extends RigidBody2D


class_name RigidBox

var max_speed = 20

func _integrate_forces(state: Physics2DDirectBodyState) -> void:
	if self.linear_velocity.length() > max_speed:
		var direction = self.linear_velocity.normalized()
		self.linear_velocity = direction * max_speed
