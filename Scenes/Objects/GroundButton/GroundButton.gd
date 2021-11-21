extends StaticBody2D

class_name GroundButton

onready var animated_sprite: AnimatedSprite = $AnimatedSprite
onready var unpressed_collision: CollisionPolygon2D = $UnpressedCollision
onready var pressed_collision: CollisionPolygon2D = $PressedCollision

var is_button_pressed: bool = false


func press_button() -> void:
	is_button_pressed = true
	unpressed_collision.set_deferred("disabled", true)
	pressed_collision.set_deferred("disabled", false)
	animated_sprite.play("Pressed")
	open_stone_gate()
	
func unpress_button() -> void:
	is_button_pressed = false
	unpressed_collision.set_deferred("disabled", false)
	pressed_collision.set_deferred("disabled", true)
	animated_sprite.play("Unpressed")
	close_stone_gate()


func open_stone_gate() -> void:
	get_node("StoneGate").open_stone_gate()
	

func close_stone_gate() -> void:
	get_node("StoneGate").close_stone_gate()


func _on_PressDetector_body_entered(body: Node) -> void:
	if body is RigidBox or body is Player:
		if is_button_pressed == false:
			press_button()


func _on_PressDetector_body_exited(body: Node) -> void:
	if body is RigidBox or body is Player:
		if is_button_pressed == true:
			unpress_button()
