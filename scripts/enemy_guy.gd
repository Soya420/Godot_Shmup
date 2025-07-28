extends CharacterBody2D

@onready var player = $"../Player"
@onready var animation_enemy = $AnimatedSprite2D

signal guy_died

var health = 1
var is_dead = false
var is_hurt = false
var hurt_timer = 0.0
const HURT_DURATION = 0.05

func _ready():
	# Add to enemies group for easy cleanup
	add_to_group("enemies")

func _physics_process(_delta: float) -> void:
	if is_hurt:
		hurt_timer -= _delta
		if hurt_timer <= 0:
			is_hurt = false
	
	if not is_dead:
		var direction = global_position.direction_to(player.global_position)
		velocity = direction * (200 + randi() % 25)
		move_and_slide()
		walk_animations(direction)

func deal_damage():
	if not is_dead:
		health -= 5
		var direction = global_position.direction_to(player.global_position)
		
		is_hurt = true
		hurt_timer = HURT_DURATION
		
		if health <= 0:
			die(direction)
			

# All Animation Functions: Die, Take Damage and Walk
func die(direction):
	is_dead = true
	velocity = Vector2.ZERO	
	# Emit signal to notify that guy died (for score)
	guy_died.emit()
	
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
	
	await get_tree().create_timer(0.45).timeout
	
	var exp_scene = preload("res://scenes/exp.tscn")
	if exp_scene != null:
		var exp_drop = exp_scene.instantiate()
		if exp_drop != null:
			exp_drop.global_position = global_position
			var current_scene = get_tree().current_scene
			if current_scene != null:
				current_scene.add_child(exp_drop)
	
	queue_free()

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
