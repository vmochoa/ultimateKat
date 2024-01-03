extends CharacterBody2D


var BASE_SPEED = 150
var SPRINT_SPEED = 200
var SPEED = BASE_SPEED
const JUMP_VELOCITY = -450.0
var on_wall = false
const WALL_JUMP_VELOCITY = Vector2(250, -350) # Ajusta según sea necesario
@onready var animated_sprite_2d = $AnimatedSprite2D

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
	
	# Handle Jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction (input_axis) and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_x = int(Input.is_action_pressed("moveRight")) - int(Input.is_action_pressed("moveLeft"))
	var sprintPress = Input.is_action_pressed("sprint")
	if sprintPress:
		SPEED = SPRINT_SPEED
	else:
		SPEED = BASE_SPEED
	
	if input_x:
		velocity.x = input_x * SPEED
		update_animations(input_x)
	
	else:
		velocity.x = move_toward(velocity.x, 0, 12)
	on_wall = is_on_wall()

	if on_wall and Input.is_action_pressed("wall_grab"):
		velocity.y = 0

	# Handle Wall Jump
	if on_wall and Input.is_action_just_pressed("jump"):
		velocity = WALL_JUMP_VELOCITY
		if animated_sprite_2d.flip_h: # Si está mirando hacia la izquierda
			velocity.x *= -1 # Cambia la dirección del salto de pared

	
	move_and_slide()
	


func update_animations(input_axis):
	if input_axis != 0:
		animated_sprite_2d.flip_h = input_axis < 0
		animated_sprite_2d.play("run")
	else:
		animated_sprite_2d.play("idle")
		
	if not is_on_floor():
		animated_sprite_2d.play("jump")
