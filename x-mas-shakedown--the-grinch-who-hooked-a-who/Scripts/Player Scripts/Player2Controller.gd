extends CharacterBody2D

const SPEED = 300.0
const JUMP_VELOCITY = -800.0

# Get gravity from project settings to be consistent with rigid bodies
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var currentAttack = "";
@onready var crouching = false;
var Grinch = true;
func _physics_process(delta):
	# Add gravity
	if not is_on_floor():
		velocity.y += gravity * delta
	var body
	var punch;
	var light;
	var heavie;
	var kick;
	var player;
	if Grinch:
		body = get_node("GrinchBody");
		punch = get_node("GrinchPunch");
		light = get_node("GrinchLight");
		heavie = get_node("GrinchHeavie");
		kick = get_node("GrinchKick");
	#movement for P2
	# Handle jump
	if Input.is_action_just_pressed("P2Up") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	if Input.is_action_just_released("P2Down") and is_on_floor() and crouching == true:
		crouching = false;
		body.scale.y = body.scale.y * 2;
	if Input.is_action_just_pressed("P2Down") and is_on_floor() and crouching == false:
		crouching = true;
		body.scale.y = body.scale.y / 2;
	# Get input direction (-1, 0, 1) and handle left/right movement
	var direction = Input.get_axis("P2Left", "P2Right")
	if direction:
		velocity.x = direction * SPEED
	else:
		# Smoothly stop (learping)
		velocity.x = move_toward(velocity.x, 0, SPEED / 7)
	velocity.y += gravity * delta
	#attacks
	
	if Input.is_action_just_pressed("P2Punch") && currentAttack == "":
		print("P2 Punched");
		punch.disabled = false;
		punch.show()
		currentAttack = "punch";
		await get_tree().create_timer(0.2).timeout
		punch.disabled = true;
		punch.hide();
		currentAttack = "";
	if Input.is_action_just_pressed("P2Kick") && currentAttack == "":
		print("P2 Kicked");
		kick.disabled = false;
		kick.show()
		currentAttack = "kick"
		await get_tree().create_timer(0.3).timeout
		kick.disabled = true;
		kick.hide();
		currentAttack = "";
	if Input.is_action_just_pressed("P2Heavie") && currentAttack == "":
		print("P2 Heavied");
		heavie.disabled = false;
		heavie.show()
		currentAttack = "heavie";
		await get_tree().create_timer(0.5).timeout
		heavie.disabled = true;
		heavie.hide();
		currentAttack = "";
	if Input.is_action_just_pressed("P2Light") && currentAttack == "":
		print("P2 Slashed");
		light.disabled = false;
		light.show()
		currentAttack = "light";
		await get_tree().create_timer(0.4).timeout
		light.disabled = true;
		light.hide();
		currentAttack = "";
	move_and_slide()
	
