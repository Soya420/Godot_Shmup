extends CharacterBody2D

@onready var animation_player = $PlayerAnimation

signal health_depleted
var health = 100
const DAMAGE_RATE = 10.0

func _physics_process(delta):
	var direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	velocity = direction * 200
	move_and_slide()
	handle_animations(direction, velocity)

	var overlapping_hitboxes = %HurtBox.get_overlapping_areas()
	if overlapping_hitboxes.size() > 0:
		health -= DAMAGE_RATE * overlapping_hitboxes.size() * delta
		%ProgressBar.value = health
		if health <= 0.0:
			health_depleted.emit()


func handle_animations(direction, velocity):
	if direction.length() == 0 && velocity.length() == 0:
		animation_player.play("idle")
		return
	if velocity.length() > 0:
		if direction.x < 0 && direction.y == 0: # Left
			animation_player.flip_h = false
			animation_player.play("walk_left-right")
		elif direction.x > 0 && direction.y == 0: # Right
			animation_player.flip_h = true
			animation_player.play("walk_left-right")
		elif direction.x < 0 && direction.y != 0: # Diagonal Left (both up and down)
			animation_player.flip_h = false
			animation_player.play("walk_diagonal")
		elif direction.x > 0 && direction.y != 0: # Diagonal Right (both up and down)
			animation_player.flip_h = true
			animation_player.play("walk_diagonal")
		else: # Up and Down
			animation_player.play("walk_up-down")
