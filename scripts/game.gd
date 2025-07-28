extends Node2D

var score = 0
var high_score = 0

func _ready():
	%ScoreLabel.text = "Score: " + str(score)
	%GameOver/ColorRect/HighScore.text = "Highscore: " + str(high_score)

func spawn_spider():
	var new_spider = preload("res://scenes/enemy_spider.tscn").instantiate()
	%PathFollow2D.progress_ratio = randf()
	new_spider.global_position = %PathFollow2D.global_position
	new_spider.spider_died.connect(_on_spider_died)
	add_child(new_spider)

func spawn_guy():
	var new_guy = preload("res://scenes/enemy_guy.tscn").instantiate()
	%PathFollow2D.progress_ratio = randf()
	new_guy.global_position = %PathFollow2D.global_position
	new_guy.guy_died.connect(_on_guy_died)
	add_child(new_guy)

func _on_spider_died():
	score += 1
	%ScoreLabel.text = "Score: " + str(score)

func _on_guy_died():
	score += 2
	%ScoreLabel.text = "Score: " + str(score)

func _on_timer_spider_timeout() -> void:
	spawn_spider()
func _on_timer_guy_timeout() -> void:
	spawn_guy()


func _on_player_health_depleted():
	%TimerSpider.stop()
	%TimerGuy.stop()
	await get_tree().create_timer(1).timeout
	
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
	get_tree().paused = false
	reset_game()

func reset_game():
	print("Resetting game...")
	score = 0
	%ScoreLabel.text = "Score: " + str(score)
	clear_enemies()
	reset_player()
	
	%GameOver.visible = false
	%ProgressBar.visible = true
	%ScoreLabel.visible = true
	
	%TimerSpider.start()
	%TimerGuy.start()

func clear_enemies():
	# Remove all enemy spiders from the scene
	var enemies = get_tree().get_nodes_in_group("enemies")
	for enemy in enemies:
		enemy.queue_free()
	
	# Remove all bullets from the scene
	var bullets = get_tree().get_nodes_in_group("bullets")
	for bullet in bullets:
		bullet.queue_free()
	
	# Remove all exp items from the scene
	var exp_items = get_tree().get_nodes_in_group("exp")
	for exp_item in exp_items:
		exp_item.queue_free()

func reset_player():
	%Player.health = 100
	%Player.is_dead = false
	%Player.set_physics_process(true)
	%ProgressBar.value = 100
	%Player.global_position = Vector2.ZERO
	
	var weapon = %Player.get_node("Weapon")
	weapon.can_shoot = true
	weapon.shoot_timer = 0.0
	weapon.RATE_OF_FIRE = 0.25 # Reset to default rate of fire


func _on_game_over_exit_button_pressed() -> void:
	print("Exit button pressed!")
	get_tree().quit()
