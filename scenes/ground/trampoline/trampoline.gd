extends Area2D

@export var bounce_power := 200
@export var max_launch := 300

@onready var animation_player: AnimationPlayer = %AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	body_entered.connect(on_player_touch)
	
func on_player_touch(body: Node2D) -> void:
	if !Global.is_present:
		return
	if body is Player:
		animation_player.play("trampoline")
		var player := body as Player
		print("Player velocity: ", player.velocity.y)
		if player.velocity.y > 0:
			player.velocity.y = max(-player.velocity.y - bounce_power, -max_launch)
