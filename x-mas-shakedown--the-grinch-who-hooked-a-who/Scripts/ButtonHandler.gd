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
	print("moves button pressed")
	mainMenu.hide()
	controlls.show()
func _exitButtonPressed():
	print("_exitButtonPressed button pressed")
func _playButtonPressed():
	print("_playButtonPressed button pressed")
	mainMenu.hide()
	characterSelect.show()
func _sallyBackButtonPressed():
	print("_sallyBackButtonPressed button pressed")
	sallyControlls.hide()
	controlls.show()
func _grinchBackButtonPressed():
	print("_grinchBackButtonPressed button pressed")
	grinchControlls.hide()
	controlls.show()
func _backButtonPressed():
	print("_backButtonPressed button pressed")
	controlls.hide()
	mainMenu.show()
func _sallyControllsButtonPressed():
	print("_sallyControllsButtonPressed button pressed")
	controlls.hide()
	sallyControlls.show()
func _grinchControllsButtonPressed():
	print("_grinchControlsButtonPressed button pressed")
	controlls.hide()
	grinchControlls.show();
func _replayButtonPressed():
	print("replay button pressed")
func _sallyWhoPickButtonPressed():
	print("_sallyWhoPickButtonPressed button pressed")
func _grinchPickButtonPressed():
	print("_grinchPickButtonPressed button pressed")
func _characterSelectBackButtonPressed():
	print("_characterSelectBackButtonPressed button pressed")
	characterSelect.hide()
	mainMenu.show()
func _fightButtonPressed():
	print("_fightButtonPressed button pressed")
	characterSelect.hide()
	#make it display the fight sceen
