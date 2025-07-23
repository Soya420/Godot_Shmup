extends AnimatedSprite2D

func setup(start_position: Vector2, _direction: Vector2) -> void:

	var offset_distance = 0.0 
	var side_offset = 40.0 
	
	position = start_position + Vector2(offset_distance, side_offset)
	rotation = deg_to_rad(90)
	
	play("default")
	animation_finished.connect(_on_animation_finished)

func _on_animation_finished() -> void:
	queue_free()
