extends CharacterBody2D


var speed = 700.0

@onready var ray_cast: RayCast2D = $RayCast

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var direction := -1

func _physics_process(delta):
	handle_gravity(delta)
	handle_collision()
	handle_movement(delta)
	handle_animations()

	move_and_slide()


func handle_gravity(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta


func handle_collision():
	if ray_cast.is_colliding():
		speed *= -1.0
		ray_cast.target_position.x *= -1.0


func handle_movement(delta):
	velocity.x = direction * speed * delta


func handle_animations():
	pass
