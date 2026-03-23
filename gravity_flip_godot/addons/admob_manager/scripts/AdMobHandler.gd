extends Node

# Signal when ads are loaded or fail
signal interstitial_loaded
signal interstitial_failed(error_code)
signal interstitial_closed

# AdMob Unit IDs (Replace with your own from AdMob Dashboard)
var ios_interstitial_id = "ca-app-pub-3940256099942544/4411468910" # Test ID
var android_interstitial_id = "ca-app-pub-3940256099942544/1033173712" # Test ID

var _ad_interface = null
var _ad_instance = null

func _ready():
	# Identify current platform and load appropriate plugin
	if OS.get_name() == "Android":
		if Engine.has_singleton("AdMob"):
			_ad_instance = Engine.get_singleton("AdMob")
			print("AdMob: Android Singleton detected.")
	elif OS.get_name() == "iOS":
		if Engine.has_singleton("AdMob"):
			_ad_instance = Engine.get_singleton("AdMob")
			print("AdMob: iOS Singleton detected.")
	
	if _ad_instance:
		_ad_instance.connect("interstitial_loaded", _on_interstitial_loaded)
		_ad_instance.connect("interstitial_failed_to_load", _on_interstitial_failed)
		_ad_instance.connect("interstitial_closed", _on_interstitial_closed)
		load_interstitial()

func load_interstitial():
	if _ad_instance:
		var ad_id = android_interstitial_id if OS.get_name() == "Android" else ios_interstitial_id
		_ad_instance.load_interstitial(ad_id)

func show_interstitial_with_probability(probability: float = 0.5):
	"""
	Shows an interstitial ad based on a given percentage (0.0 to 1.0).
	Example: 0.3 means 30% chance.
	"""
	if randf() <= probability:
		if _ad_instance and _ad_instance.is_interstitial_loaded():
			print("AdMob: Showing ad by probability.")
			_ad_instance.show_interstitial()
			return true
		else:
			print("AdMob: Ad not ready or singleton missing.")
			load_interstitial() # Pre-load for next time
	else:
		print("AdMob: Skipping ad due to probability.")
	return false

# --- Internal Signal Handlers ---

func _on_interstitial_loaded():
	print("AdMob: Interstitial loaded successfully.")
	emit_signal("interstitial_loaded")

func _on_interstitial_failed(error_code):
	print("AdMob: Interstitial failed to load: ", error_code)
	emit_signal("interstitial_failed", error_code)

func _on_interstitial_closed():
	print("AdMob: Interstitial closed.")
	emit_signal("interstitial_closed")
	load_interstitial() # Re-load for next time
