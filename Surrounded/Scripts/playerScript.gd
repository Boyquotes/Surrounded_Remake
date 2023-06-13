extends CharacterBody2D

@onready var animations = $AnimationTree
@onready var effects = $player_effects
@onready var animationModes = animations.get("parameters/playback")
@onready var stats = GlobalScript.playerData

const accel = 1000.0
const friction = 600.0
const bulletPath = preload("res://GameObjects/bullet.tscn")

var input = Vector2.ZERO
var isShooting : bool = false

func _ready():
	GlobalScript.player = self
	
func _exit_tree():
	GlobalScript.player = null
	
func _process(_delta):
	if stats.health <= 0:
		queue_free()
	
	if velocity == Vector2.ZERO:
		animationModes.travel("idle")
	else:
		animationModes.travel("walking")
		animations.set("parameters/idle/blend_position", velocity)
		animations.set("parameters/walking/blend_position", velocity)
	
	if Input.is_action_just_pressed("shoot()") and isShooting == false:
		shoot()
	
	$gun_pivot.look_at(get_global_mouse_position())
	
func _physics_process(delta):
	if isShooting == false:
		player_movement(delta)
	
func get_input():
	input.x = int(Input.is_action_pressed("moveRight")) - int(Input.is_action_pressed("moveLeft"))
	input.y = int(Input.is_action_pressed("moveDown")) - int(Input.is_action_pressed("moveUp"))
	return input.normalized()
	
func player_movement(delta):
	input = get_input()
	
	if input == Vector2.ZERO:
		if velocity.length() > (friction * delta):
			velocity = velocity.normalized() * (friction * delta)
		else:
			velocity = Vector2.ZERO
	else:
		velocity += (input * accel * delta)
		velocity = velocity.limit_length(stats.speed)
		
	move_and_slide()
	
func shoot():
	var bullet = bulletPath.instantiate()
	get_parent().add_child(bullet)
	bullet.global_position = $gun_pivot/gunpoint.global_position
	bullet.velocity = get_global_mouse_position() - bullet.position
	animations.set("parameters/shooting/blend_position", position.direction_to(get_global_mouse_position()))
	
	animationModes.travel("shooting")
	isShooting = true
	$shoot_cooldown.start()
	
func _on_shoot_cooldown_timeout():
	isShooting = false
	
func _on_player_hitbox_area_entered(area):
	if area.is_in_group("zombie"):
		stats.health -= 1
		effects.play("hurt")
