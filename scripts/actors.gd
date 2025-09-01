#extends Node2D


# Function to wrap position around screen edges
static func wrap_position(pos: Vector2, screen_size: Vector2) -> Vector2:
	var BORDER_GIVE := 30
	var wrapped_pos = pos
	if wrapped_pos.x > screen_size.x + BORDER_GIVE:
		wrapped_pos.x = 0 - (BORDER_GIVE / 2)
	elif wrapped_pos.x < 0 - BORDER_GIVE:
		wrapped_pos.x = screen_size.x  + (BORDER_GIVE / 2)

	if wrapped_pos.y > screen_size.y + BORDER_GIVE:
		wrapped_pos.y = 0  - (BORDER_GIVE / 2)
	elif wrapped_pos.y < 0 - BORDER_GIVE:
		wrapped_pos.y = screen_size.y  + (BORDER_GIVE / 2)

	return wrapped_pos
