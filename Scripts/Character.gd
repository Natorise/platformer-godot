extends DefaultCharacter



@onready var animation_player = get_node("AnimationPlayer")


@onready var respawn_position  = position
@onready var sprite = get_node("Sprite2D")
@onready var sprite_width = sprite.texture.get_width()

# airjumping
const AIRJUMP_COUNT = 2
var airjumps_remaining = AIRJUMP_COUNT

#dashing
var dashing = false
var can_dash = true
var dash_time_since = 0 
var DASH_LENGTH = .2
const DASH_SPEED = 4

#walljumping
var walljumping = true
var walljump_time = 0
const WALLJUMP_LENGTH = .3
const WALLJUMP_SPEED = 2 

@export var lives = 5

func _physics_process(delta):
	super(delta)
	
	var direction = Input.get_axis("walk_left","walk_right")

#	walljump timer
	if(walljumping):
		walljump_time += delta
		if(walljump_time > WALLJUMP_LENGTH):
			walljumping = false

#	dash timer
	if(dashing):
		dash_time_since+= delta
		if(dash_time_since > DASH_LENGTH): 
			dashing = false
			can_dash = false
	
	
#	reset airjump & dash if on floor
	if(is_on_floor()):
		airjumps_remaining = AIRJUMP_COUNT
		can_dash = true


#	jumping , walljumping, airjumping
	if(Input.is_action_just_pressed("jump")):
		if(is_on_floor()):

			jump()
			
		elif(is_on_wall()):
			jump()
			velocity.x = direction*-1 * SPEED * WALLJUMP_SPEED
			walljumping = true
			walljump_time = 0 
			
		elif(airjumps_remaining > 0):
			airjumps_remaining-=1
			jump()



#	walking & sprinting
	if(not dashing and not walljumping):
		var speed = SPEED * direction
		if(Input.is_action_pressed("sprint")): speed *= SPRINT_SPEED
		velocity.x = speed

#	dashing
	if(Input.is_action_just_pressed("dash") and can_dash and not dashing):
		velocity.x = SPEED*direction*DASH_SPEED
		dashing = true
		can_dash = false
		dash_time_since = 0


#	apply movements
	move_and_slide()

#	detect collisions
	var touched_spike = false
	for index in get_slide_collision_count():
		var collision = get_slide_collision(index)
		var body = collision.get_collider()
		
#		kill if spike
		if(not touched_spike and body.is_in_group("Spike")): 
			touched_spike = true
			respawn()
#		enemy collisions
		elif(body.is_in_group("Enemy")):
			var normal = collision.get_normal()
			if(normal.y <0):
				jump()
				body.kill()
			else: 
				respawn()
#		win if reach flag
		elif(body.is_in_group("Flag")):
			get_tree().change_scene_to_file("res://Scenes/YouWin.tscn")
			

#	set position if out of bounds
	if(position.y > 720): respawn()
	position.x = clamp(position.x,0 + sprite_width/4,10000)
	



func respawn():
	animation_player.play("dying")

func _on_animation_player_animation_finished(anim_name):
	if(anim_name == "dying"):
		lives -= 1
		animation_player.stop()
		
		if(lives<= 0):
			get_tree().change_scene_to_file("res://Scenes/YouLose.tscn")
		else:
			position = respawn_position
			velocity = Vector2(0,0)

