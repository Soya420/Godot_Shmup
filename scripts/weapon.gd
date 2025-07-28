extends Area2D

@onready var player = get_parent()
@onready var pivot_point = $PivotPoint
@onready var bullet_hole = $PivotPoint/AnimatedSprite2D/BulletHole

const BULLET_SCENE = preload("res://scenes/bullet.tscn")
const SHOOT_SCENE = preload("res://scenes/shoot_animation.tscn")

var shoot_timer: float = 0.0
var RATE_OF_FIRE: float = 0.3
var can_shoot: bool = true

func _on_exp_pickup():
	# Decrease rate of fire (faster shooting) but don't let it go below 0.05
	RATE_OF_FIRE = max(0.05, RATE_OF_FIRE - 0.005)
	print("Rate of fire improved! New rate: ", RATE_OF_FIRE)

func _physics_process(delta: float) -> void:
	if player.is_dead:
		return
		
	var direction = get_global_mouse_position() - player.global_position
	
	pivot_point.rotation = direction.angle()
	
	if shoot_timer > 0:
		shoot_timer -= delta
		if shoot_timer <= 0:
			can_shoot = true
	
	if Input.is_action_pressed("shoot") and can_shoot:
		shoot()

func shoot():
	if player.is_dead:
		return
		
	var bullet = BULLET_SCENE.instantiate()
	var shoot_direction = (get_global_mouse_position() - bullet_hole.global_position).normalized()
	bullet.setup(bullet_hole.global_position, shoot_direction)
	get_tree().current_scene.add_child(bullet)
	
	var shoot_animation = SHOOT_SCENE.instantiate()
	bullet_hole.add_child(shoot_animation)
	shoot_animation.setup(bullet_hole.position, shoot_direction)
	
	# Reset shooting timer
	can_shoot = false
	shoot_timer = RATE_OF_FIRE
