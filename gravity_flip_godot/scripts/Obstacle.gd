extends Area2D

@export var speed = 400.0

func _physics_process(delta):
	position.x -= speed * delta
	
	if position.x < -100:
		queue_free()

func _on_body_entered(body):
	if body.name == "Player":
		if body.has_method("die"):
			body.die()
