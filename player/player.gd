extends CharacterBody2D


const SPEED = 130.0
const JUMP_FORCE = -250.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var is_jumping: bool = false

@onready var animation: AnimatedSprite2D = $Animation
@onready var coyote_timer: Timer = $CoyoteTimer


func _physics_process(delta):
	handle_gravity(delta)
	handle_jump()

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("Left", "Right")
	
	handle_movement(direction)
	
	handle_animations()
	
	var was_on_floor = is_on_floor()
	
	# Checking if the player collided with a spike and calling the take_damage function
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		if collision:
			if collision.get_collider().name == "Spikes":
				take_damage()
	
	move_and_slide()
	
	# Starting coyote timer after the player just left a ledge
	var just_left_ledge = was_on_floor and !is_on_floor() and velocity.y >= 0
	if just_left_ledge:
		coyote_timer.start()


func handle_jump():
	# Handle Jump.
	if is_on_floor() or coyote_timer.time_left > 0.0:
		if Input.is_action_pressed("Jump"):
			velocity.y = JUMP_FORCE
			coyote_timer.stop()
	
	# Cutting the jump short after button is released (For variable jump height)
	#if !Input.is_action_pressed("Jump") and velocity.y < 0:
		#velocity.y = 0


func handle_gravity(delta):
	# Add the gravity.
	if !is_on_floor():
		velocity.y += gravity * delta
		is_jumping = true
	elif is_on_floor():
		is_jumping = false


func handle_movement(direction):
	if direction != 0:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)


func handle_animations():
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


func take_damage():
	get_tree().reload_current_scene()


func _on_hurt_box_body_entered(body: CharacterBody2D) -> void:
	if body.is_in_group("enemies"):
		get_tree().reload_current_scene()
		
