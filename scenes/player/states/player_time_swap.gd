extends State

@export var player: Player

@onready var time_swap_timer: Timer = %TimeSwapTimer

func _ready() -> void:
	time_swap_timer.timeout.connect(on_timeout)

func _enter() -> void:
	super()
	time_swap_timer.start()
	player.animation_player.stop()
	player.velocity = Vector2.ZERO
	Global.time_swap_initiated.emit()
	#player.time_swap_camera.enabled = true
	animate()

func on_timeout() -> void:
	player.is_time_swapping = false
	Global.time_swap_finished.emit()
	state_finished.emit()

func animate() -> void:
	var tween := get_tree().create_tween()
	tween.tween_property(%TimeSwapCamera, "zoom", Vector2.ONE * 4, 1.5)
	tween.tween_callback(finish_animating)

func finish_animating() -> void:
	var tween := get_tree().create_tween()
	tween.tween_property(%TimeSwapCamera, "zoom", Vector2.ONE, 0.2)
	#tween.tween_callback(func() -> void: player.time_swap_camera.enabled = false)
