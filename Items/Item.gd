extends Area2D

const HeartCollectSound = preload("res://Effects/HeartCollectSound.tscn")

func play_pick_up_sound():
	var heartCollectSound = HeartCollectSound.instance()
	get_tree().current_scene.add_child(heartCollectSound)
