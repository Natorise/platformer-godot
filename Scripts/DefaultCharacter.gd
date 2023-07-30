class_name DefaultCharacter extends CharacterBody2D

const SPEED = 300
const SPRINT_SPEED =1.8
const JUMP_VELOCITY = -700
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _physics_process(delta):
#	gravity
	if(not is_on_floor() and gravity):
		velocity.y += gravity * delta

func jump():
	velocity.y = JUMP_VELOCITY
