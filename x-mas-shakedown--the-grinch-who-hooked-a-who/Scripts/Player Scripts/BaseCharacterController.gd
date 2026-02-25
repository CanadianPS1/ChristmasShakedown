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
var anim_sprite: AnimatedSprite2D  # set in _ready(); null-safe throughout
func _ready():
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
	punch.body_entered.connect(_on_hurtbox_entered.bind("punch"))
	kick.body_entered.connect(_on_hurtbox_entered.bind("kick"))
	light.body_entered.connect(_on_hurtbox_entered.bind("light"))
	heavie.body_entered.connect(_on_hurtbox_entered.bind("heavie"))

	# Animated sprite — built at runtime so both characters share this script
	anim_sprite = get_node_or_null("AnimatedSprite2D")
	if anim_sprite:
		_setup_animations()

# Build SpriteFrames programmatically so no texture paths are hard-coded in .tscn.
# Both Grinch and Sally share this script; Sally's tint is set via modulate on the node.
func _setup_animations() -> void:
	var frames := SpriteFrames.new()
	frames.remove_animation("default")

	# ── idle (loops) ───────────────────────────────────────────────────────────
	frames.add_animation("idle")
	frames.set_animation_loop("idle", true)
	frames.set_animation_speed("idle", 8.0)
	for i in range(6):
		frames.add_frame("idle", load("res://Assets/GrinchSprites/Grinch_Idle/tile%03d.png" % i))

	# ── punch  (used for punch / light / heavie attacks; plays once) ───────────
	frames.add_animation("punch")
	frames.set_animation_loop("punch", false)
	frames.set_animation_speed("punch", 12.0)
	for i in range(6):
		frames.add_frame("punch", load("res://Assets/GrinchSprites/Grinch_punch/tile%03d.png" % i))

	# ── kick (plays once) ──────────────────────────────────────────────────────
	frames.add_animation("kick")
	frames.set_animation_loop("kick", false)
	frames.set_animation_speed("kick", 10.0)
	for i in range(6):
		frames.add_frame("kick", load("res://Assets/GrinchSprites/Grinch_kick/tile%03d.png" % i))

	# ── crouch (single static frame, holds until released) ────────────────────
	frames.add_animation("crouch")
	frames.set_animation_loop("crouch", false)
	frames.set_animation_speed("crouch", 1.0)
	frames.add_frame("crouch", load("res://Assets/GrinchSprites/Grinch_crouch/GrinchSpritesheet_crouch.png"))

	anim_sprite.sprite_frames = frames
	anim_sprite.play("idle")

# Call this after setting player_id to apply player-specific initialization
func apply_player_id():
	prefix = "P" + str(player_id)
	if player_id == 2:
		facing = -1
	else:
		facing = 1
	scale.x = facing
	var character = GameState.player1_character if player_id == 1 else GameState.player2_character
	print("Player " + str(player_id) + " character: " + character)
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
		if anim_sprite and currentAttack == "":
			anim_sprite.play("crouch")
	elif Input.is_action_just_released(prefix + "Down") and crouching:
		crouching = false
		body_shape.height *= 2
		body.position.y = 0.0
		if anim_sprite and currentAttack == "":
			anim_sprite.play("idle")

	


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

	# Play the matching attack animation
	if anim_sprite:
		match attack_name:
			"punch", "light", "heavie":
				anim_sprite.play("punch")
			"kick":
				anim_sprite.play("kick")

	await get_tree().create_timer(duration).timeout
	hurtbox.get_node("CollisionShape2D").disabled = true
	hurtbox.hide
	currentAttack = ""

	# Return to the appropriate idle/crouch animation
	if anim_sprite:
		if crouching:
			anim_sprite.play("crouch")
		else:
			anim_sprite.play("idle")

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
		body._take_damage(damage, player_id)
		
	
	
func _take_damage(damage: float, attacker_id: int):
	if current_health > 0:
		current_health -= damage
		if current_health <= 0:
			GameState.on_player_win(attacker_id)
	
	

	
