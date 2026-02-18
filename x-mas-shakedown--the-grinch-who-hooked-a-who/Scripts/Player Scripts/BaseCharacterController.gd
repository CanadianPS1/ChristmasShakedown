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
var body_shape
var facing = 1  # 1 = right, -1 = left
func _ready():
	prefix = "P" + str(player_id)
	body   = get_node("Hitbox")
	print(body)
	punch  = get_node("PunchHurtbox")
	light  = get_node("LightHurtbox")
	heavie = get_node("HeavyHurtbox")
	kick   = get_node("KickHurtbox")
	body_shape = body.shape
	punch.get_node("CollisionShape2D").disabled = true
	punch.hide
	light.get_node("CollisionShape2D").disabled = true
	light.hide
	heavie.get_node("CollisionShape2D").disabled = true
	heavie.hide
	kick.get_node("CollisionShape2D").disabled = true
	kick.hide
	if player_id == 2:
		facing = -1
	else:
		facing = 1
	scale.x = facing 
	
	punch.body_entered.connect(_on_hurtbox_entered.bind("punch"))
	kick.body_entered.connect(_on_hurtbox_entered.bind("kick"))
	light.body_entered.connect(_on_hurtbox_entered.bind("light"))
	heavie.body_entered.connect(_on_hurtbox_entered.bind("heavie"))
func _physics_process(delta):

	# Gravity
	if not is_on_floor():
		velocity.y += gravity * delta

	# Jump
	if Input.is_action_just_pressed(prefix + "Up") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Crouch
	if Input.is_action_just_pressed(prefix + "Down") and not crouching:
		crouching = true
		body_shape.height /= 2
		body.position.y = 50.0
	elif Input.is_action_just_released(prefix + "Down") and crouching:
		crouching = false
		body_shape.height *= 2
		body.position.y = 0.0

	


	var direction = Input.get_axis(prefix + "Left", prefix + "Right")

	if direction:
		velocity.x = direction * SPEED
		facing = sign(direction)
		if facing == -1:
			transform.x = Vector2(-1, 0)
		else:
			transform.x = Vector2(1, 0)
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
func _do_attack(attack_name: String, hurtbox, duration: float):
	print("P" + str(player_id) + " used " + attack_name)
	currentAttack = attack_name
	hurtbox.get_node("CollisionShape2D").disabled = false
	hurtbox.show
	await get_tree().create_timer(duration).timeout
	hurtbox.get_node("CollisionShape2D").disabled = true
	hurtbox.hide
	currentAttack = ""

func _on_hurtbox_entered(body, attack_name):
	if body == self:
		return  # ignore self
	
	var damage = 0.0
	match attack_name:
		"punch": damage = 10.0
		"kick": damage = 15.0
		"light": damage = 12.0
		"heavie": damage = 25.0
	
	if body.has_method("_take_damage"):
		body._take_damage(damage)
		
	
	
func _take_damage(damage: float):
	if current_health > 0:
		current_health -= damage
	elif current_health <= 0:
		_player_win(player_id)
	
	
func _player_win(player_id: int):
	print("THis Player wins")
	print(player_id)
