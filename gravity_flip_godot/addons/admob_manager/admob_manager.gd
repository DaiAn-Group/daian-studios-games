@tool
extends EditorPlugin

func _enter_tree():
	# Register the singleton for global access
	add_autoload_singleton("AdMob", "res://addons/admob_manager/scripts/AdMobHandler.gd")

func _exit_tree():
	# Clean up
	remove_autoload_singleton("AdMob")
