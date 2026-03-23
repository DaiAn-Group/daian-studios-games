extends Node2D

@onready var player = $Player
@onready var score_label = $CanvasLayer/ScoreLabel
@onready var game_over_ui = $CanvasLayer/GameOver
@onready var spawner = $Spawner

var score = 0
var game_active = false
var speed = 400.0

func _ready():
	game_over_ui.visible = false
	start_game()

func _process(delta):
	if game_active:
		score += delta * 10
		score_label.text = str(int(score))
		
		# Move background or parallax here
		$ParallaxBackground.scroll_offset.x -= speed * delta * 0.5
		
		# Increase difficulty
		speed += delta * 5

func _input(event):
	if event is InputEventScreenTouch and event.pressed:
		if game_active:
			player.flip()
		elif game_over_ui.visible:
			restart_game()

	# Also support mouse/space for desktop testing
	if event.is_action_pressed("ui_accept") or event is InputEventMouseButton:
		if event.pressed:
			if game_active:
				player.flip()
			elif game_over_ui.visible:
				restart_game()

func start_game():
	game_active = true
	score = 0
	speed = 400.0
	spawner.start_spawning()

func _on_player_game_over():
	game_active = false
	game_over_ui.visible = true
	spawner.stop_spawning()
	
	# Show an interstitial ad with a 50% chance
	if has_node("/root/AdMob"):
		get_node("/root/AdMob").show_interstitial_with_probability(1.0)
	
	# Save high score here

func restart_game():
	get_tree().reload_current_scene()
