extends CharacterBody2D

@export var player_id = 1
@export var magneDir = 1

const SPEED = 130.0
const JUMP_VELOCITY = -300.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var powerActive = false
var posDif = global_position
var distance = 0
var attract:= Vector2(0,0)
var repel = 0

@onready var animated_sprite = $AnimatedSprite2D
@onready var magne_area = $AreaMagne
@onready var collisionP = $CollisionShape2D

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump_%s" % [player_id]) and is_on_floor():
		velocity.y = JUMP_VELOCITY
	
	if Input.is_action_just_pressed("jump_%s" % [player_id]) and is_on_ceiling():
		velocity.y = -1*JUMP_VELOCITY
	
	if Input.is_action_just_pressed("switch_%s" % [player_id]):
		if magneDir==2:
			magneDir=1
		else:
			magneDir = 2
		
	if Input.is_action_just_pressed("power_%s" % [player_id]):
		powerActive = true
	if Input.is_action_just_released("power_%s" % [player_id]):
		powerActive = false
		
	
	# Get the input direction: -1, 0, 1
	var direction = Input.get_axis("move_left_%s" % [player_id], "move_right_%s" % [player_id])
	
	# magnets powers
	for area in magne_area.get_overlapping_areas():
			if area.name == "AreaMagne":
				posDif = (area.get_parent().global_position - global_position)
				distance = area.get_parent().global_position.distance_to(global_position)
				if powerActive==true and distance<100:
						if area.get_parent().magneDir!=magneDir:
							attract = posDif / distance**0.9
							global_position += attract
							if gravity>0 and is_on_ceiling():
								gravity *= -1
						else:
							repel = (posDif/200) * (pow(2,(100-distance)/16))
							global_position -= repel
				if gravity<0 and is_on_ceiling() and (area.get_parent().global_position.y>global_position.y):
					gravity *= -1
	if distance>70 and gravity<0:
		gravity *= -1
	# Flip the Sprite
	if direction > 0:
		animated_sprite.flip_h = false
	elif direction < 0:
		animated_sprite.flip_h = true
	
	if is_on_ceiling() and gravity<0:
		animated_sprite.flip_v=true
		if direction == 0:
			animated_sprite.play("idle_%s" % [magneDir])
		else:
			animated_sprite.play("run_%s" % [magneDir])
	else:
		animated_sprite.flip_v=false
	
	# Play animations
	if is_on_floor():
		if direction == 0:
			animated_sprite.play("idle_%s" % [magneDir])
		else:
			animated_sprite.play("run_%s" % [magneDir])
	
	if not(is_on_ceiling() or is_on_floor()):
		animated_sprite.play("jump_%s" % [magneDir])
	
	# Apply movement
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	
	move_and_slide()
	


