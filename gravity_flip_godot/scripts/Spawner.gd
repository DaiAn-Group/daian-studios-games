extends Node2D

@export var obstacle_scene: PackedScene
@onready var timer = $Timer

var speed = 400.0

func start_spawning():
	timer.start()

func stop_spawning():
	timer.stop()

func _on_timer_timeout():
	var obstacle = obstacle_scene.instantiate()
	obstacle.position.x = 800  # Spawn off-screen right
	obstacle.speed = speed
	
	# Randomize Y position (top or bottom)
	if randi() % 2 == 0:
		obstacle.position.y = 100 # Top
		obstacle.rotation_degrees = 180 # Flip sprite
	else:
		obstacle.position.y = 1180 # Bottom
	
	add_child(obstacle)
	
	# Decrease spawn time slightly for difficulty
	if timer.wait_time > 0.5:
		timer.wait_time -= 0.01
