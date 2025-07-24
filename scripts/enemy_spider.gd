extends CharacterBody2D

@onready var player = $"../Player"
@onready var animation_enemy = $AnimatedSprite2D

var health = 3
var is_dead = false
var is_hurt = false
var hurt_timer = 0.0
const HURT_DURATION = 0.05

func _physics_process(_delta: float) -> void:
	if is_hurt:
		hurt_timer -= _delta
		if hurt_timer <= 0:
			is_hurt = false
	
	if not is_dead:
		var direction = global_position.direction_to(player.global_position)
		velocity = direction * (90 + randi() % 20)
		move_and_slide()
		walk_animations(direction)

func deal_damage():
	if not is_dead:
		health -= 1
		var direction = global_position.direction_to(player.global_position)
		
		is_hurt = true
		hurt_timer = HURT_DURATION
		
		take_dmg(direction)
		if health <= 0:
			die(direction)


# All Animation Functions: Die, Take Damage and Walk
func die(direction):
	is_dead = true
	velocity = Vector2.ZERO
	
	if direction.x > 0 && direction.y < 0: # Bottom Left of player
		animation_enemy.flip_h = false
		animation_enemy.play("die_up")
	elif direction.x < 0 && direction.y < 0: # Bottom Right of player
		animation_enemy.flip_h = true
		animation_enemy.play("die_up")
	elif direction.x > 0 && direction.y > 0: # Top Left of player
		animation_enemy.flip_h = false
		animation_enemy.play("die_down")
	elif direction.x < 0 && direction.y > 0: # Top Right of player
		animation_enemy.flip_h = true
		animation_enemy.play("die_down")
	
	await get_tree().create_timer(0.6).timeout
	queue_free()

func take_dmg(direction):
	if direction.x > 0 && direction.y < 0: # Bottom Left of player
		animation_enemy.flip_h = false
		animation_enemy.play("hurt_up")
	elif direction.x < 0 && direction.y < 0: # Bottom Right of player
		animation_enemy.flip_h = true
		animation_enemy.play("hurt_up")
	elif direction.x > 0 && direction.y > 0: # Top Left of player
		animation_enemy.flip_h = false
		animation_enemy.play("hurt_down")
	elif direction.x < 0 && direction.y > 0: # Top Right of player
		animation_enemy.flip_h = true
		animation_enemy.play("hurt_down")

func walk_animations(direction):
	if not is_dead and not is_hurt:
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
