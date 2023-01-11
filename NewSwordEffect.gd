extends Area2D

export(int) var damage = 1;
export(Vector2) var knockback_vector = Vector2.ZERO

var direction = Vector2.ZERO
export var speed = 200

onready var wallCollsionEffect = $WallCollisionEffect

func _process(delta):
	translate(direction.normalized() * speed * delta)


func _on_VisibilityNotifier2D_screen_exited():
	queue_free()


func _on_NewSwordEffect_body_entered(body):
	wallCollsionEffect.play("animate")
	queue_free()
