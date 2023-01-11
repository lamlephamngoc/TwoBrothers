extends Area2D

const CollectSound = preload("res://Effects/HeartCollectSound.tscn")

var showPopup = false;
var FRICTION = 200;

onready var popup = $PopupDialog
onready var timer = $Timer
onready var label = $PopupDialog/Label

func _on_Door_body_entered(body):
	if PlayerStats.keys >= 1:
		PlayerStats.keys -= 1
		get_tree().get_nodes_in_group("Achivement")[0].update_achivement()
		var collectSound = CollectSound.instance()
		get_tree().current_scene.add_child(collectSound)
		label.text = "Congratulation!!! You win Level 1"
		popup.visible = true
		timer.start(1)
		queue_free()
		# Load level 2
		get_tree().change_scene("res://Levels/Level002.tscn")
	else:
		print("Don't have key")
		var player = get_tree().current_scene.find_node("Player")
		# push back opposite with player direction
		var direction = player.roll_vector
		player.position = player.position - Vector2(10,0) if direction.x > 0 else player.position + Vector2(10,0)
		player.position = player.position - Vector2(0,10) if direction.y > 0 else player.position + Vector2(0,10)
		popup.set_global_position(global_position + Vector2(-30, -50))
		popup.visible = true
		timer.start(1)

func _on_Timer_timeout():
	popup.visible = false
