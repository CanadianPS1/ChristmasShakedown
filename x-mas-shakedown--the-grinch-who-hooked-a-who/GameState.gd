extends Node

var player1_score = 0
var player2_score = 0
var current_round = 1
var rounds_to_win = 3  # best of 3
var game_winner_id
func on_player_win(winning_player_id: int):
	if winning_player_id == 1:
		player1_score += 1
	else:
		player2_score += 1
	
	print("Player " + str(winning_player_id) + " wins round " + str(current_round))
	current_round += 1
	
	# check if someone has won the match
	if player1_score >= rounds_to_win || player2_score >= rounds_to_win:
		if player1_score > player2_score:
			game_winner_id = 1
		elif player2_score > player1_score:
			game_winner_id = 2
		
		get_tree().change_scene_to_file("res://sceens/PlayerWins.tscn")
		print("Winner" + str(game_winner_id))
	else:
		# nobody has won the match yet, start next round
		get_tree().reload_current_scene()
