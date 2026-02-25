extends Node2D

func _ready():
	var grinch = $Grinch
	var sally = $Sally

	# Assign player_id based on which character each player selected
	if GameState.player1_character == "grinch":
		grinch.player_id = 1
		sally.player_id = 2
	else:
		# Player 1 selected Sally; Player 2 gets Grinch
		sally.player_id = 1
		grinch.player_id = 2

	# Apply the now-correct player_id to each character node
	grinch.apply_player_id()
	sally.apply_player_id()

	# Position each character at the spawn point matching their player_id
	grinch.position = $Player1Spawn.position if grinch.player_id == 1 else $Player2Spawn.position
	sally.position = $Player1Spawn.position if sally.player_id == 1 else $Player2Spawn.position
