extends CharacterBody2D

@onready var player = $"../Player"
@onready var animation_enemy = $AnimatedSprite2D

func _physics_process(delta: float) -> void:
	var direction = global_position.direction_to(player.global_position)
	velocity = direction * (90 + randi()%20)
	move_and_slide()
	handle_animations(direction)


func handle_animations(direction: Vector2) -> void:
	if direction.x > 0 && direction.y < 0: # Bottom Left of player
		animation_enemy.flip_h = false
		animation_enemy.play("run_up")
	elif direction.x < 0 && direction.y < 0: # Bottom Right of player
		animation_enemy.flip_h = true
		animation_enemy.play("run_up")
	elif direction.x > 0 && direction.y > 0: # Top Left of player
		animation_enemy.flip_h = false
		animation_enemy.play("run_down")
	elif direction.x < 0 && direction.y > 0: # Top Right of player
		animation_enemy.flip_h = true
		animation_enemy.play("run_down")
