extends Node2D

func spawn_mob():
	var new_spider = preload("res://scenes/enemy_spider.tscn").instantiate()
	%PathFollow2D.progress_ratio = randf()
	new_spider.global_position = %PathFollow2D.global_position
	add_child(new_spider)


func _on_timer_timeout() -> void:
	spawn_mob()
