extends Label

func _physics_process(delta):
	if Input.is_action_just_pressed("help"):
		visible = false if visible else true

func _on_Timer_timeout():
	visible = false
