extends Node2D

var score = 0
var high_score = 0

func _ready():
	%ScoreLabel.text = "Score: " + str(score)
	# Initialize high score display
	%GameOver/ColorRect/HighScore.text = "Highscore: " + str(high_score)

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
	# Stop spawning more enemies
	$Timer.stop()
	
	await get_tree().create_timer(1).timeout
	
	# Update high score if current score is higher
	if score > high_score:
		high_score = score
	
	%GameOver.visible = true
	%ProgressBar.visible = false
	%ScoreLabel.visible = false
	# Update the game over labels
	%GameOver/ColorRect/FinalScore.text = "Final Score: " + str(score)
	%GameOver/ColorRect/HighScore.text = "Highscore: " + str(high_score)
	get_tree().paused = true

func _on_replay_button_pressed() -> void:
	print("Replay button pressed!")
	# Reset game state
	get_tree().paused = false
	reset_game()

func reset_game():
	print("Resetting game...")
	# Reset score
	score = 0
	%ScoreLabel.text = "Score: " + str(score)
	# Clear all enemies
	clear_enemies()
	# Reset player
	reset_player()
	
	# Hide game over screen
	%GameOver.visible = false
	%ProgressBar.visible = true
	%ScoreLabel.visible = true
	
	# Restart enemy spawning
	$Timer.start()

func clear_enemies():
	# Remove all enemy spiders from the scene
	var enemies = get_tree().get_nodes_in_group("enemies")
	for enemy in enemies:
		enemy.queue_free()
	
	# Remove all bullets from the scene
	var bullets = get_tree().get_nodes_in_group("bullets")
	for bullet in bullets:
		bullet.queue_free()

func reset_player():
	# Reset player health and state
	%Player.health = 100
	%Player.is_dead = false
	%Player.set_physics_process(true)
	%ProgressBar.value = 100
	# Reset player position to center
	%Player.global_position = Vector2.ZERO
	
	# Reset weapon state
	var weapon = %Player.get_node("Weapon")
	weapon.can_shoot = true
	weapon.shoot_timer = 0.0


func _on_game_over_exit_button_pressed() -> void:
	print("Exit button pressed!")
	get_tree().quit()
