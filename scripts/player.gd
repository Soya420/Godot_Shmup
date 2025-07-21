extends CharacterBody2D

@onready var animation_player = $PlayerAnimation

func _physics_process(_delta: float) -> void:
	var direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	velocity = direction * 200
	move_and_slide()
	handle_animations(direction)

func handle_animations(direction: Vector2) -> void:
	if direction.length() == 0:
		animation_player.play("idle")
		return

	if direction.x < 0 && direction.y == 0:        # Left
		animation_player.flip_h = false
		animation_player.play("walk_left-right")
	elif direction.x > 0 && direction.y == 0:      # Right
		animation_player.flip_h = true
		animation_player.play("walk_left-right")
	elif direction.x < 0 && direction.y != 0:      # Diagonal Left (both up and down)
		animation_player.flip_h = false
		animation_player.play("walk_diagonal")
	elif direction.x > 0 && direction.y != 0:      # Diagonal Right (both up and down)
		animation_player.flip_h = true
		animation_player.play("walk_diagonal")
	else:                                          # Up and Down
		animation_player.play("walk_up-down")
		

		
