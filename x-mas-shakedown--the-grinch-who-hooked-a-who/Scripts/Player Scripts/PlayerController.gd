extends CharacterBody2D

const SPEED = 300.0
const JUMP_VELOCITY = -800.0


# Get gravity from project settings to be consistent with rigid bodies
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _physics_process(delta):
	# Add gravity
	if not is_on_floor():
		velocity.y += gravity * delta

	# Handle jump
	if Input.is_action_just_pressed("Jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY


	# Get input direction (-1, 0, 1) and handle left/right movement
	var direction = Input.get_axis("Left", "Right")
	if direction:
		velocity.x = direction * SPEED
	else:
		# Smoothly stop (learping)
		velocity.x = move_toward(velocity.x, 0, SPEED / 7)
	velocity.y += gravity * delta
	move_and_slide()
