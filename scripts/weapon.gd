extends Area2D

@onready var player = get_parent()
@onready var pivot_point = $PivotPoint
@onready var bullet_hole = $PivotPoint/AnimatedSprite2D/BulletHole

const BULLET_SCENE = preload("res://scenes/bullet.tscn")

var shoot_timer: float = 0.0
const RATE_OF_FIRE: float = 0.25
var can_shoot: bool = true

func _physics_process(delta: float) -> void:
	var direction = get_global_mouse_position() - player.global_position
	
	pivot_point.rotation = direction.angle()
	
	if shoot_timer > 0:
		shoot_timer -= delta
		if shoot_timer <= 0:
			can_shoot = true
	
	if Input.is_action_pressed("shoot") and can_shoot:
		shoot()

func shoot():
	var bullet = BULLET_SCENE.instantiate()
	var shoot_direction = (get_global_mouse_position() - player.global_position).normalized()
	bullet.setup(bullet_hole.global_position, shoot_direction)
	get_tree().current_scene.add_child(bullet)
	
	# Reset shooting timer
	can_shoot = false
	shoot_timer = RATE_OF_FIRE
