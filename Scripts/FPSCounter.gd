extends RichTextLabel

var time_since = 0
var time_required = 1

var frames_since = 0

func _process(delta):
	time_since += delta
	frames_since +=1
	if(time_since > time_required):
		set_text(str(round(1/delta)) +" FPS")
		time_since = 0
		frames_since = 0
