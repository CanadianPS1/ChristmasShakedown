extends Node2D

# Maps the character name (as stored in GameState) to its prefab scene.
# Add new characters here when you create them.
const CHARACTER_SCENES: Dictionary = {
	"grinch": preload("res://Sceens/Grinch.tscn"),
	"sally":  preload("res://Sceens/Sally.tscn"),
}

func _ready():
	# Instantiate each player's chosen character separately.
	# Both players can pick the same character — each gets their own independent instance.
	var p1: CharacterBody2D = CHARACTER_SCENES[GameState.player1_character].instantiate()
	var p2: CharacterBody2D = CHARACTER_SCENES[GameState.player2_character].instantiate()

	p1.player_id = 1
	p2.player_id = 2

	add_child(p1)
	add_child(p2)

	# apply_player_id sets the input prefix, facing direction, and scale after _ready() has run.
	p1.apply_player_id()
	p2.apply_player_id()

	# Place each character at their spawn marker.
	p1.position = $Player1Spawn.position
	p2.position = $Player2Spawn.position
