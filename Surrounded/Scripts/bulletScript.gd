extends CharacterBody2D

var bulletSpeed = 250.0

func _physics_process(delta):
	var _collisionInfo = move_and_collide(velocity.normalized() * delta * bulletSpeed)
