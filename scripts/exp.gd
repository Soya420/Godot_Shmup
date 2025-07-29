extends Area2D

func _ready():
	# Add to exp group for easy cleanup
	add_to_group("exp")
	
	# Connect area entered signal for player collection
	if not body_entered.is_connected(_on_body_entered):
		body_entered.connect(_on_body_entered)

func _on_body_entered(body):
	# Check if player collected the exp
	if body != null and body.name == "Player":
		# Get the player's weapon and improve rate of fire
		var weapon = body.get_node("Weapon")
		if weapon != null and weapon.has_method("_on_exp_pickup"):
			weapon._on_exp_pickup()
		
		# Remove the exp orb
		queue_free()
