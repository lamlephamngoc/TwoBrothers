extends Area2D

const CollectSound = preload("res://Effects/HeartCollectSound.tscn")

func _on_Key_body_entered(body):
	PlayerStats.keys += 1
	get_tree().get_nodes_in_group("Achivement")[0].update_achivement()
	var collectSound = CollectSound.instance()
	get_tree().current_scene.add_child(collectSound)
	queue_free()
