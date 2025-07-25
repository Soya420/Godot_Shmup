extends Node2D

var score = 0

func _ready():
	%ScoreLabel.text = "Score: " + str(score)

func spawn_mob():
	var new_spider = preload("res://scenes/enemy_spider.tscn").instantiate()
	%PathFollow2D.progress_ratio = randf()
	new_spider.global_position = %PathFollow2D.global_position
	
	new_spider.spider_died.connect(_on_spider_died)
	
	add_child(new_spider)

func _on_spider_died():
	score += 1
	%ScoreLabel.text = "Score: " + str(score)


func _on_timer_timeout() -> void:
	spawn_mob()


func _on_player_health_depleted():
	await get_tree().create_timer(1).timeout
	%GameOver.visible = true
	%ProgressBar.visible = false
	%ScoreLabel.visible = false
	# Update the game over label to show final score
	%GameOver/ColorRect/FinalScore.text = "Final Score: " + str(score)
	get_tree().paused = true
