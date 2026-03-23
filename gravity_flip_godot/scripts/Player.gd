extends CharacterBody2D

signal game_over

const GRAVITY_STRENGTH = 2000.0
const FLIP_SPEED = 0.2

var gravity_dir = 1
var is_flipping = false

@onready var sprite = $Sprite2D
@onready var collision_shape = $CollisionShape2D

func _ready():
	velocity = Vector2.ZERO

func _physics_process(delta):
	# Apply gravity
	velocity.y += GRAVITY_STRENGTH * gravity_dir * delta
	
	# Clamp velocity to avoid tunneling
	velocity.y = clamp(velocity.y, -1500, 1500)

	move_and_slide()
	
	# Check for floor/ceiling collision (optional, depends on level design)
	if is_on_floor() or is_on_ceiling():
		pass # Can add landing particles here

func flip():
	gravity_dir *= -1
	
	# Visual feedback
	var tween = create_tween()
	tween.tween_property(sprite, "rotation_degrees", sprite.rotation_degrees + 180, FLIP_SPEED)
	tween.parallel().tween_property(sprite, "scale", Vector2(0.8, 1.2), FLIP_SPEED * 0.5)
	tween.parallel().tween_property(sprite, "scale", Vector2(1.0, 1.0), FLIP_SPEED * 0.5).set_delay(FLIP_SPEED * 0.5)

func die():
	emit_signal("game_over")
	queue_free()
