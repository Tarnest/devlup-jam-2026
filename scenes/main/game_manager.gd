extends Node

signal feather_collect
var is_menu: bool = true

func _ready() -> void:
	feather_collect.connect(_on_feather_collect)

func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("reset"):
		var level_number: int = Global.collected_collectibles + 1
		get_tree().call_deferred("change_scene_to_file", "res://scenes/levels/level%d.tscn" % level_number)

func _on_feather_collect() -> void:
	var level_number: int = Global.collected_collectibles + 1
	get_tree().call_deferred("change_scene_to_file", "res://scenes/levels/level%d.tscn" % level_number)
