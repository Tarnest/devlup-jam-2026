class_name Player
extends CharacterBody2D

@export var speed := 400
@export var jump_speed := 800
@export var gravity := 60

@onready var interact: Area2D = %Interact
@onready var reach: CollisionShape2D = $Interact/CollisionShape2D
@onready var climbing: Area2D = %Climbing
@onready var animation_player: AnimationPlayer = %AnimationPlayer
@onready var sprite: Sprite2D = %Sprite2D
@onready var time_swap_camera: Camera2D = %TimeSwapCamera
@onready var audio_stream_player_sfx: AudioStreamPlayer2D = %PlayerAudioStreamPlayerSFX
@onready var clock_forward: AudioStream = preload("res://sfx/clockforwardnopitch.mp3")
@onready var clock_backward: AudioStream = preload("res://sfx/clockbackwardnopitch.mp3")
@onready var plant: AudioStream = preload("res://sfx/plant.mp3")

var time_locked: bool = false;

var is_time_swapping := false
var is_climbing := false
var direction: Vector2: 
	set(_direction):
		direction = _direction
		if direction != Vector2.ZERO:
			last_direction = direction
	get:
		return direction
var last_direction := Vector2.ZERO
var current_item: Item
var current_climb_position: Vector2

func _ready() -> void:
	Global.player = self
	Global.player_carry.connect(on_player_carry)
	Global.time_swap_initiated.connect(_on_time_swap_initiated)

func _physics_process(_delta: float) -> void:
	if !is_on_floor() && !is_climbing && !is_time_swapping:
		velocity.y += gravity
	
	move_and_slide()
	
	if last_direction == Vector2.RIGHT:
		interact.position.x = abs(interact.position.x)
	if last_direction == Vector2.LEFT:
		interact.position.x = -abs(interact.position.x)
	
	if Input.is_action_just_pressed("climb_up") && !is_climbing:
		var areas := interact.get_overlapping_areas()
		if areas.size() > 0:
			for area: Node in areas:
				if area is Vines:
					var interactable: Vines = area as Vines
					interactable.interact()
	
	if Input.is_action_just_pressed("interact"):
		for item: Interactable in get_tree().get_nodes_in_group("interactables"):
			if (!item.is_visible_in_tree() || is_ancestor_of(item) || !item.is_in_reach(self)):
				continue;
			item.interact();
			break;
	

func on_player_carry(item: Item, scene: PackedScene) -> void:
	if current_item != null:
		return;
	item.queue_free()

	var new_item: Item = scene.instantiate()
	add_child(new_item)
	new_item.position = Vector2(0, -20)
	current_item = new_item
	
	audio_stream_player_sfx.stream = plant
	audio_stream_player_sfx.play()
	
func _on_time_swap_initiated() -> void:
	if Global.is_present:
		audio_stream_player_sfx.stream = clock_backward
	else:
		audio_stream_player_sfx.stream = clock_forward
	audio_stream_player_sfx.play()
