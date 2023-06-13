extends CharacterBody2D

@onready var effects = $zombie_effects
@onready var animations = $AnimationTree
@onready var hitBox = $zombie_hitbox/hitbox
@onready var collisionBox = $zombie_collision
@onready var animationModes = animations.get("parameters/playback")

var health = 3
var speed = 50.0

func _process(delta):
	if GlobalScript.player != null:
		velocity = global_position.direction_to(GlobalScript.player.global_position)
	else:
		velocity = Vector2.ZERO
	
	if velocity == Vector2.ZERO and health != 0:
		animationModes.travel("idle")
	elif health <= 0:
		dead()
	else:
		animationModes.travel("running")
		animations.set("parameters/idle/blend_position", velocity)
		animations.set("parameters/running/blend_position", velocity)
		animations.set("parameters/dead/blend_position", velocity)
	
	global_position += velocity * speed * delta
	
func _on_zombie_hitbox_area_entered(area):
	if area.is_in_group("enemyDamager"):
		effects.play("isHit")
		health -= 1
		area.get_parent().queue_free()
	
func dead():
	animationModes.travel("dead")
	velocity = Vector2.ZERO
	collisionBox.disabled = true
	hitBox.disabled = true
