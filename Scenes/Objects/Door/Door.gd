extends Area2D

export var next_scene: PackedScene


func _on_Door_body_entered(body: Node) -> void:
	if body is Player:
		SoundManager.level_complete_sound.play()
		SceneManager.change_scene(next_scene, "DarkFade")
