extends CharacterBody2D

const SPEED = 300.0
const JUMP_VELOCITY = -800.0
const MAX_HEALTH = 100.0
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var currentAttack = ""
var crouching = false
var current_health = MAX_HEALTH
# Set this to 1 or 2 in the Inspector, or before the node is ready
@export var player_id: int = 1

# Derived action name prefix — set automatically from player_id
var prefix: String

var body
var punch
var light
var heavie
var kick

func _ready():
	prefix = "P" + str(player_id)

func _physics_process(delta):
#	if Grinch:
	body   = get_node("GrinchBody")
#		punch  = get_node("GrinchPunch")
#		light  = get_node("GrinchLight")
#		heavie = get_node("GrinchHeavie")
#		kick   = get_node("GrinchKick")

	# Gravity
	if not is_on_floor():
		velocity.y += gravity * delta

	# Jump
	if Input.is_action_just_pressed(prefix + "Up") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Crouch
	if Input.is_action_just_pressed(prefix + "Down") and not crouching:
		crouching = true
		body.scale.y /= 2

	if Input.is_action_just_released(prefix + "Down") and is_on_floor() and crouching:
		crouching = false
		body.scale.y *= 2

	# Horizontal movement
	var direction = Input.get_axis(prefix + "Left", prefix + "Right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED / 7)

	velocity.y += gravity * delta

	# Attacks
	if Input.is_action_just_pressed(prefix + "Punch") and currentAttack == "":
		_do_attack("punch", punch, 0.2)
	if Input.is_action_just_pressed(prefix + "Kick") and currentAttack == "":
		_do_attack("kick", kick, 0.3)
	if Input.is_action_just_pressed(prefix + "Heavie") and currentAttack == "":
		_do_attack("heavie", heavie, 0.5)
	if Input.is_action_just_pressed(prefix + "Light") and currentAttack == "":
		_do_attack("light", light, 0.4)

	move_and_slide()


#Attack / damage handeling
func _do_attack(attack_name: String, hitbox, duration: float):
	print("P" + str(player_id) + " used " + attack_name)
	currentAttack = attack_name
	hitbox.disabled = false
	hitbox.show()
	await get_tree().create_timer(duration).timeout
	hitbox.disabled = true
	hitbox.hide()
	currentAttack = ""


func _take_damage(damage: float):
	if current_health > 0:
		current_health -= damage
	elif current_health <= 0:
		#Need to create player win state
		#this can just send you to a new screen with that 
		#tells you that current player wins
		print("Player Wins")
	
