extends RichTextLabel

@onready var char = get_node("/root/Game/Character")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	set_text( str(char.lives) +" Lives")
