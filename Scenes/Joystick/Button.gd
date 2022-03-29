extends TouchScreenButton

var button_radius = Vector2(8, 8)

onready var button_area_node = get_parent()
var button_area_radius = 18

# No finger touching to make a move = arbitrarily set to -1, because 
# Godot will set index to 0 if there is ONE finger touching, it will
# set index to 1 if TWO fingers touching, etc...
var finger_touch_index = -1


func _input(event: InputEvent) -> void:
	# Handle the player touching the screen
	if event is InputEventScreenTouch and event.is_pressed():
		var event_distance_to_center = (event.get_position() - button_area_node.get_position()).length()
		# Check that the player touched inside ButtonArea which is a valid input for moving the player
		if event_distance_to_center <= button_area_radius:
			finger_touch_index = event.get_index()
			self.set_global_position(event.get_position() - button_radius)
			set_player_action(get_button_center_position())
	# Handle the finger dragging on screen
	elif event is InputEventScreenDrag:
		# Check that the finger touching the screen is the valid finger that initially made the touch
		if event.get_index() == finger_touch_index:
			var event_distance_to_center = (event.get_position() - button_area_node.get_position()).length()
			# Handle the finger dragging on screen within the button area
			if event_distance_to_center <= button_area_radius:
				self.set_global_position(event.get_position() - button_radius)
				set_player_action(get_button_center_position())
			else:
				self.set_position(((event.get_position() - button_area_node.get_position()).normalized() * button_area_radius - button_radius))
				set_player_action(get_button_center_position())
	# Handle player releasing the finger that touched the screen to make player move
	elif event is InputEventScreenTouch and not event.is_pressed() and event.get_index() == finger_touch_index:
		finger_touch_index = -1


func _process(delta: float) -> void:
	if finger_touch_index == -1:
		var center = Vector2(0, 0) # Button position relative to center of ButtonArea is (0, 0)
		var button_position_to_center = get_button_center_position() - center
		self.set_position(self.get_position() - button_position_to_center)
		set_player_action(get_button_center_position())


func get_button_center_position() -> Vector2:
	return self.get_position() + button_radius


func get_direction():
	return get_button_center_position().normalized()


func set_player_action(button_position) -> void:
	var pos_x = get_button_center_position().x
	if pos_x > 0:
		self.set_action("ui_right")
	elif pos_x < 0:
		self.set_action("ui_left")
	else:
		self.set_action("")
