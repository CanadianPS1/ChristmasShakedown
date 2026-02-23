extends Node2D
@onready var movesButton = get_node("MainMenu/MovesButton")
@onready var exitButton = get_node("MainMenu/ExitButton")
@onready var playButton = get_node("MainMenu/PlayButton")
@onready var sallyBackButton = get_node("SallyControlls/BackButton")
@onready var grinchBackButton = get_node("GrinchControlls/BackButton")
@onready var backButton = get_node("Controlls/BackButton")
@onready var sallyControllsButton = get_node("Controlls/SallyWho")
@onready var grinchControllsButton = get_node("Controlls/Grinch")
@onready var replayButton = get_node("PostGame/ReplayButton")
@onready var exitToMainMenuButton = get_node("PostGame/ExitToMainMenuButton")
@onready var sallyWhoPickButton = get_node("CharacterSelect/SallyWho")
@onready var grinchPickButton = get_node("CharacterSelect/Grinch")
@onready var characterSelectBackButton = get_node("CharacterSelect/BackButton")
@onready var fightButton = get_node("CharacterSelect/FightButton")
@onready var selectionLabel = get_node("CharacterSelect/SelectionLabel")
@onready var mainMenu = get_node("MainMenu")
@onready var characterSelect = get_node("CharacterSelect")
@onready var postGame = get_node("PostGame")
@onready var sallyControlls = get_node("SallyControlls")
@onready var grinchControlls = get_node("GrinchControlls")
@onready var controlls = get_node("Controlls")
#lol this is a comment
func _setup_hover(btn: Button) -> void:
	btn.mouse_entered.connect(func(): btn.modulate = Color(0.7, 0.7, 0.7))
	btn.mouse_exited.connect(func():
		if not btn.has_focus():
			btn.modulate = Color(1, 1, 1)
	)
	btn.focus_entered.connect(func(): btn.modulate = Color(0.7, 0.7, 0.7))
	btn.focus_exited.connect(func(): btn.modulate = Color(1, 1, 1))

func _ready():
	movesButton.pressed.connect(_movesButtonPressed)
	exitButton.pressed.connect(_exitButtonPressed)
	playButton.pressed.connect(_playButtonPressed)
	sallyBackButton.pressed.connect(_sallyBackButtonPressed)
	grinchBackButton.pressed.connect(_grinchBackButtonPressed)
	backButton.pressed.connect(_backButtonPressed)
	sallyControllsButton.pressed.connect(_sallyControllsButtonPressed)
	grinchControllsButton.pressed.connect(_grinchControllsButtonPressed)
	replayButton.pressed.connect(_replayButtonPressed)
	sallyWhoPickButton.pressed.connect(_sallyWhoPickButtonPressed)
	grinchPickButton.pressed.connect(_grinchPickButtonPressed)
	characterSelectBackButton.pressed.connect(_characterSelectBackButtonPressed)
	fightButton.pressed.connect(_fightButtonPressed)
	# Reset selection state when the menu loads
	GameState.selection_phase = 1
	GameState.player1_character = ""
	GameState.player2_character = ""
	selectionLabel.text = "Player 1: Pick your character!"
	fightButton.hide()
	# Set up hover dim effect on every button
	for btn in [playButton, movesButton, exitButton,
			sallyWhoPickButton, grinchPickButton, characterSelectBackButton, fightButton,
			replayButton, exitToMainMenuButton,
			sallyControllsButton, grinchControllsButton, backButton,
			grinchBackButton, sallyBackButton]:
		_setup_hover(btn)
	# Give the first main-menu button focus so controllers can navigate immediately
	playButton.grab_focus()
func _movesButtonPressed():
	var sound = get_node("MainMenu/MovesButton/buttonSoundPlayer");
	sound.play()
	mainMenu.hide()
	controlls.show()
	sallyControllsButton.grab_focus()
func _exitButtonPressed():
	var sound = get_node("MainMenu/ExitButton/buttonSoundPlayer");
	sound.play()
	get_tree().quit()
func _playButtonPressed():
	var sound = get_node("MainMenu/PlayButton/buttonSoundPlayer");
	sound.play()
	mainMenu.hide()
	characterSelect.show()
	grinchPickButton.grab_focus()
func _sallyBackButtonPressed():
	var sound = get_node("SallyControlls/BackButton/buttonSoundPlayer");
	sound.play()
	sallyControlls.hide()
	controlls.show()
	sallyControllsButton.grab_focus()
func _grinchBackButtonPressed():
	var sound = get_node("GrinchControlls/BackButton/buttonSoundPlayer");
	sound.play()
	grinchControlls.hide()
	controlls.show()
	sallyControllsButton.grab_focus()
func _backButtonPressed():
	var sound = get_node("Controlls/BackButton/buttonSoundPlayer");
	sound.play()
	controlls.hide()
	mainMenu.show()
	playButton.grab_focus()
func _sallyControllsButtonPressed():
	var sound = get_node("SallyControlls/BackButton/buttonSoundPlayer");
	sound.play()
	controlls.hide()
	sallyControlls.show()
	sallyBackButton.grab_focus()
func _grinchControllsButtonPressed():
	var sound = get_node("GrinchControlls/BackButton/buttonSoundPlayer");
	sound.play()
	controlls.hide()
	grinchControlls.show()
	grinchBackButton.grab_focus()
func _replayButtonPressed():
	print("replay button pressed")
func _sallyWhoPickButtonPressed():
	if GameState.selection_phase == 1:
		GameState.player1_character = "sally"
		GameState.selection_phase = 2
		selectionLabel.text = "Player 2: Pick your character!"
		print("Player 1 selected: Sally Who")
	elif GameState.selection_phase == 2:
		GameState.player2_character = "sally"
		GameState.selection_phase = 0
		selectionLabel.text = "P1: " + GameState.player1_character + "  |  P2: " + GameState.player2_character
		fightButton.show()
		fightButton.grab_focus()
		print("Player 2 selected: Sally Who")

func _grinchPickButtonPressed():
	if GameState.selection_phase == 1:
		GameState.player1_character = "grinch"
		GameState.selection_phase = 2
		selectionLabel.text = "Player 2: Pick your character!"
		print("Player 1 selected: Grinch")
	elif GameState.selection_phase == 2:
		GameState.player2_character = "grinch"
		GameState.selection_phase = 0
		selectionLabel.text = "P1: " + GameState.player1_character + "  |  P2: " + GameState.player2_character
		fightButton.show()
		fightButton.grab_focus()
		print("Player 2 selected: Grinch")
func _characterSelectBackButtonPressed():
	var sound = get_node("CharacterSelect/BackButton/buttonSoundPlayer");
	sound.play()
	# Reset selection so a fresh pick happens next time
	GameState.selection_phase = 1
	GameState.player1_character = ""
	GameState.player2_character = ""
	selectionLabel.text = "Player 1: Pick your character!"
	fightButton.hide()
	characterSelect.hide()
	mainMenu.show()
	playButton.grab_focus()
func _fightButtonPressed():
	var sound = get_node("CharacterSelect/FightButton/buttonSoundPlayer");
	sound.play();
	await get_tree().create_timer(1).timeout;
	get_tree().change_scene_to_file("res://Sceens/GamePlay.tscn")
	#make it display the fight sceen
