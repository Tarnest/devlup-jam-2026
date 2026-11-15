extends StateMachine

@export var player: Player

@onready var idle_state: State = %Idle
@onready var move_state: State = %Move
@onready var jump_state: State = %Jump
@onready var climb_state: State = %Climb
@onready var time_swap_state: State = %TimeSwap
@onready var audio_stream_player_sfx: AudioStreamPlayer2D = %PlayerAudioStreamPlayerSFX
@onready var jump: AudioStream = preload("res://sfx/jump.mp3")

func _ready() -> void:
	change_state(state)
	time_swap_state.state_finished.connect(on_time_swap_state_finished)
	Global.player_climb.connect(on_player_climb)
	Global.change_to_past.connect(stop_climbing)

func _physics_process(_delta: float) -> void:
	if Input.is_action_pressed("time_swap") && !player.time_locked:
		player.is_time_swapping = true
		change_state(time_swap_state)
	elif !player.is_climbing && !player.is_time_swapping:
		if Input.is_action_pressed("jump") && player.is_on_floor():
			change_state(jump_state)
			audio_stream_player_sfx.stream = jump
			audio_stream_player_sfx.play()
		elif Input.is_action_pressed("move") || player.velocity != Vector2.ZERO:
			change_state(move_state)
		else:
			change_state(idle_state)
	elif Input.is_action_pressed("jump") && !player.is_time_swapping:
		change_state(jump_state)
	
func on_player_climb(climb_position: Vector2) -> void:
	player.is_climbing = true
	player.current_climb_position = climb_position
	change_state(climb_state)

func stop_climbing() -> void:
	change_state(move_state)

func on_time_swap_state_finished() -> void:
	change_state(idle_state)
