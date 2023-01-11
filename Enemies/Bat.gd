extends KinematicBody2D

const EnemyDeathEffect = preload("res://Effects/EnemyDeathEffect.tscn")
const Heart = preload("res://Items/Heart.tscn")
var knockback = Vector2.ZERO

onready var stats = $Stats
onready var playerDectionZone = $PlayerDetectionZone
onready var sprite = $AnimatedSprite
onready var hurtBox = $Hurtbox
onready var softCollision = $SoftCollision
onready var wanderController = $WanderController
onready var animationPlayer = $AnimationPlayer

export var ACCELERATION = 300
export var MAX_SPEED = 50
export var FRICTION = 200
export var WANDER_TARGET_RANGE = 4

enum {
	IDLE,
	WANDER,
	CHASE
}

var state = IDLE
var velocity = Vector2.ZERO

func _ready():
	state = pick_random_state([IDLE, WANDER])
	sprite.material.set_shader_param("active", false)
	
func _physics_process(delta):
	knockback = knockback.move_toward(Vector2.ZERO, FRICTION * delta)
	knockback = move_and_slide(knockback)
	match state:
		IDLE:
			velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
			seek_player()
			if wanderController.get_time_left() == 0:
				update_wander()
				
		WANDER:
			seek_player()
			if wanderController.get_time_left() == 0:
				update_wander()
			accelerate_towards_point(wanderController.target_position, delta)
			if global_position.distance_to(wanderController.target_position) <= WANDER_TARGET_RANGE:
				update_wander()
			
		CHASE:
			var player = playerDectionZone.player
			if player != null:
				accelerate_towards_point(player.global_position, delta)
			else:
				state = IDLE
			sprite.flip_h = velocity.x < 0
			
	if softCollision.is_colliding():
		velocity += softCollision.get_push_vector() * delta * 800
	velocity = move_and_slide(velocity)
			
func update_wander():
	state = pick_random_state([IDLE, WANDER])
	wanderController.start_wander_timer(rand_range(1, 3))
	
func accelerate_towards_point(point, delta):
	sprite.flip_h = velocity.x < 0
	var direction = global_position.direction_to(point)
	velocity = velocity.move_toward(direction * MAX_SPEED, ACCELERATION * delta)

func pick_random_state(state_list):
	state_list.shuffle()
	return state_list.pop_front()
	
func seek_player():
	if playerDectionZone.can_see_player():
		state = CHASE

func _on_Hurtbox_area_entered(area):
	var damage = stats.health - area.damage
	call_deferred("update_health", damage)
	knockback = area.knockback_vector * 120
	hurtBox.create_hit_effect()
	hurtBox.start_invincibility(0.4)

func update_health(damage):
	stats.health = damage

func _on_Stats_no_health():
	# random drop heart
	if randi() % 2 % 2 == 0:
		var heart = Heart.instance()
		heart.global_position = global_position
		get_parent().add_child(heart)
	# sound
	var enemyDeathEffect = EnemyDeathEffect.instance()
	get_parent().add_child(enemyDeathEffect)
	enemyDeathEffect.position = global_position	
	queue_free()
	# Update achivement
	PlayerStats.bats += 1
	get_tree().get_nodes_in_group("Achivement")[0].update_achivement()
	

func _on_Hurtbox_invincibility_ended():
	animationPlayer.play("Stop")

func _on_Hurtbox_invincibility_started():
	animationPlayer.play("Start")
