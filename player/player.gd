extends CharacterBody2D


const SPEED = 130.0
const JUMP_VELOCITY = -200.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

@onready var animation: AnimatedSprite2D = $Animation


func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	# Handle Jump.
	if Input.is_action_just_pressed("Jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("Left", "Right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	
	animate_player()

	move_and_slide()


func animate_player():
	if not is_on_floor():
		animation.play("Jumping")
	
	if is_on_floor():
		if velocity.x == 0:
			animation.play("Idle")
		elif velocity.x < 0 or velocity.x > 0:
			animation.play("Walking")
	
	if velocity.x < 0:
		animation.set_flip_h(true)
	elif velocity.x > 0:
		animation.set_flip_h(false)
