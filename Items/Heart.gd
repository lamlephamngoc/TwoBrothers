extends Area2D

const HeartCollectSound = preload("res://Effects/HeartCollectSound.tscn")

func _on_Heart_body_entered(body):
	PlayerStats.health += 1
	var heartCollectSound = HeartCollectSound.instance()
	get_tree().current_scene.add_child(heartCollectSound)
	queue_free()
