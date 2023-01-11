extends Area2D

const CollectSound = preload("res://Effects/HeartCollectSound.tscn")

func _on_Sword_body_entered(body):
	PlayerStats.hasStrongSword = true
	var collectSound = CollectSound.instance()
	get_tree().current_scene.add_child(collectSound)
	queue_free()
