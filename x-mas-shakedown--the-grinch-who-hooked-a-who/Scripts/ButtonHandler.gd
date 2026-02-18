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
@onready var sallyWhoPickButton = get_node("CharacterSelect/SallyWho")
@onready var grinchPickButton = get_node("CharacterSelect/Grinch")
@onready var characterSelectBackButton = get_node("CharacterSelect/BackButton")
@onready var fightButton = get_node("CharacterSelect/FightButton")
@onready var mainMenu = get_node("MainMenu")
@onready var characterSelect = get_node("CharacterSelect")
@onready var postGame = get_node("PostGame")
@onready var sallyControlls = get_node("SallyControlls")
@onready var grinchControlls = get_node("GrinchControlls")
@onready var controlls = get_node("Controlls")
#lol this is a comment
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
func _movesButtonPressed():
	mainMenu.hide()
	controlls.show()
func _exitButtonPressed():
	get_tree().quit()
func _playButtonPressed():
	mainMenu.hide()
	characterSelect.show()
func _sallyBackButtonPressed():
	sallyControlls.hide()
	controlls.show()
func _grinchBackButtonPressed():
	grinchControlls.hide()
	controlls.show()
func _backButtonPressed():
	controlls.hide()
	mainMenu.show()
func _sallyControllsButtonPressed():
	controlls.hide()
	sallyControlls.show()
func _grinchControllsButtonPressed():
	controlls.hide()
	grinchControlls.show();
func _replayButtonPressed():
	print("replay button pressed")
func _sallyWhoPickButtonPressed():
	print("_sallyWhoPickButtonPressed button pressed")
func _grinchPickButtonPressed():
	print("_grinchPickButtonPressed button pressed")
func _characterSelectBackButtonPressed():
	characterSelect.hide()
	mainMenu.show()
func _fightButtonPressed():
	get_tree().change_scene_to_file("res://Sceens/GamePlay.tscn")
	#make it display the fight sceen
