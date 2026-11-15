extends Node2D

@export var past: Node2D
@export var present: Node2D

@export var past_tileset: TileMapLayer
@export var present_tileset: TileMapLayer
@export var bridge_past_tileset: TileMapLayer
@export var bridge_present_tileset: TileMapLayer

func _ready() -> void:
	Global.is_present = true
	Global.time_swap_finished.connect(on_time_swap)

func on_time_swap() -> void:
	if present.is_visible_in_tree():
		past.visible = true
		past_tileset.collision_enabled = true
		if bridge_past_tileset != null:
			bridge_past_tileset.collision_enabled = true
		
		present.visible = false
		present_tileset.collision_enabled = false
		if bridge_present_tileset != null:
			bridge_present_tileset.collision_enabled = false
		
		Global.is_present = false
		Global.change_to_past.emit()
		Global.player.set_collision_mask_value(5, true)
	elif past.is_visible_in_tree():
		present.visible = true
		present_tileset.collision_enabled = true
		if bridge_present_tileset != null:
			bridge_present_tileset.collision_enabled = true
		
		past.visible = false
		past_tileset.collision_enabled = false
		if bridge_past_tileset != null:
			bridge_past_tileset.collision_enabled = false
		
		Global.is_present = true
		Global.change_to_present.emit()
		Global.player.set_collision_mask_value(5, false)
