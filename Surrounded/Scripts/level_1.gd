extends Node2D

@onready var zombie = preload("res://GameObjects/zombie.tscn")

func _ready():
	$zombie_spawner/spawntimer.start()
	
func _on_spawntimer_timeout():
	var zombies = zombie.instantiate()
	add_child(zombies)
	zombies.position = $zombie_spawner.position
