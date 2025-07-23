extends Area2D

var direction: Vector2
var speed: float = 750
var traveled_distance: float = 0
const RANGE: float = 1000

func _physics_process(delta: float) -> void:
	var movement = direction * speed * delta
	global_position += movement
	traveled_distance += movement.length()
	
	if traveled_distance > RANGE:
		queue_free()

func setup(start_position: Vector2, target_direction: Vector2) -> void:
	global_position = start_position
	direction = target_direction.normalized()
	rotation = direction.angle()

func _on_body_entered(body: Node2D) -> void:
	queue_free()
	if body.has_method("deal_damage"):
		body.deal_damage()
