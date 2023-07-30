extends DefaultCharacter


@onready var animation_Player = get_node("AnimationPlayer")
@onready var collision = get_node("CollisionShape2D")

var velocity_x = SPEED

func _physics_process(delta):
	super(delta)
	velocity.x = velocity_x
	move_and_slide()	
	
func kill():
	gravity = 0
	collision.queue_free()
	animation_Player.play("half_scale")

func _on_animation_player_animation_finished(anim_name):
	if(anim_name == "half_scale"):
		queue_free()

# flip walk direction every second
func _on_timer_timeout():
	velocity_x *= -1
