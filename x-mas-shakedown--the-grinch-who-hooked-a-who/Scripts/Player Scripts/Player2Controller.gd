extends CharacterBody2D

const SPEED = 300.0
const JUMP_VELOCITY = -800.0

# Get gravity from project settings to be consistent with rigid bodies
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var currentAttack = "";
var lastDirection = "";
@onready var crouching = false;
var Grinch = true;
var throwSteP2 = false;
var throwStep2 = false;
var throwStep3 = false;
var gabSteP2 = false;
var gabStep2 = false;
var gabStep3 = false;
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
	var grinchPresent;
	var grinchPresentBox;
	if Grinch:
		body = get_node("GrinchBody");
		punch = get_node("GrinchPunch");
		light = get_node("GrinchLight");
		heavie = get_node("GrinchHeavie");
		kick = get_node("GrinchKick");
		grinchPresent = get_node("GrinchPresent");
		grinchPresentBox = get_node("GrinchPresent/CollisionShape2D");
	#movement for P2
	# Handle jump
	if Input.is_action_just_pressed("P2Left") and is_on_floor():
		lastDirection = "left";
	if Input.is_action_just_pressed("P2Right") and is_on_floor():
		lastDirection = "right";
	if Input.is_action_just_pressed("P2Up") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		lastDirection = "up";
	if Input.is_action_just_released("P2Down") and is_on_floor() and crouching == true:
		crouching = false;
		body.scale.y = body.scale.y * 2;
		lastDirection = "down";
	if Input.is_action_just_pressed("P2Down") and crouching == false:
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
	if grinchPresentBox.disabled == false and is_on_floor():
		grinchPresentBox.disabled = true;
		grinchPresent.visible = false;
	if Input.is_action_just_pressed("P2Punch") && currentAttack == "":
		if(throwStep3):
			throwStep3 = false;
			#call the move
			if Grinch:
				grinchPresentBox.disabled = false;
				grinchPresent.visible = true;
				grinchPresent.position.y = body.position.y + 0.5;
				grinchPresent.velocity.x = direction + 500;
				grinchPresent.velocity.y += gravity * delta;
				print("used present throw");
		else:
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
	if lastDirection == "left" and throwSteP2 == false:
		throwSteP2 = true
		print("step 1")
	if lastDirection == "up" and throwSteP2:
		throwStep2 = true;
		throwSteP2 = false;
		print("step 2")
	if lastDirection == "right" and throwStep2:
		throwStep2 = false;
		throwStep3 = true;
		print("step 3")
	if lastDirection == "down" and gabSteP2 == false:
		throwSteP2 = true
	if lastDirection == "right" and gabSteP2:
		throwStep2 = true;
		throwSteP2 = false;
	
		
		
		
	move_and_slide()
	
