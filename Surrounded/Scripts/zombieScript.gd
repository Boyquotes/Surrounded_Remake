extends CharacterBody2D

@onready var effects = $zombie_effects
@onready var animations = $AnimationTree
@onready var animationModes = animations.get("parameters/playback")
@onready var stats = GlobalScript.enemyData

func _process(delta):
	if GlobalScript.player != null:
		velocity = global_position.direction_to(GlobalScript.player.global_position)
	
	if velocity == Vector2.ZERO and stats.health >= 0:
		animationModes.travel("idle")
	elif stats.health <= 0:
		dead()
	else:
		animationModes.travel("running")
		animations.set("parameters/idle/blend_position", velocity)
		animations.set("parameters/running/blend_position", velocity)
		animations.set("parameters/dead/blend_position", velocity)
	
	global_position += velocity * stats.speed * delta
	
func _on_zombie_hitbox_area_entered(area):
	if area.is_in_group("enemyDamager"):
		effects.play("isHit")
		stats.health -= 1
		area.get_parent().queue_free()
	
func dead():
	animationModes.travel("dead")
	velocity = Vector2.ZERO
