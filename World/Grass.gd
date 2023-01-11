extends Node2D

const GrassEffect = preload("res://Effects/GrassEffect.tscn")
const ItemKey = preload("res://Items/Key.tscn")

func create_grass_effect():
	var grassEffect = GrassEffect.instance()
	get_parent().add_child(grassEffect)
	grassEffect.global_position = global_position

func _on_Hurtbox_area_entered(area):
	create_grass_effect()
	drop_key()
	queue_free()

func drop_key():
	var grassKey = get_parent().get_node("GrassKey")
	print(grassKey)
	if self == grassKey:
		var itemKey = ItemKey.instance()
		itemKey.global_position = grassKey.global_position
		get_tree().current_scene.add_child(itemKey)
