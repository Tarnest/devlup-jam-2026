extends ShapedInteractable

@export var vines: Node2D
@export var maple_tree: Node2D
@export var pumpkin: Node2D
@onready var audio_stream_player_sfx: AudioStreamPlayer2D = %AudioStreamPlayerSFX
@onready var plant_sound: AudioStream = preload("res://sfx/plant.mp3")


var plant: Node2D

var seed: Seed
var planted := false

func _ready() -> void:
	Global.change_to_present.connect(on_change_to_present)
	Global.change_to_past.connect(on_change_to_past)
	
	if vines == null:
		print("No vines assigned")
	else:
		vines.process_mode = Node.PROCESS_MODE_DISABLED
	
	if maple_tree == null:
		print("No maple_tree assigned")
	else:
		maple_tree.process_mode = Node.PROCESS_MODE_DISABLED
	
	if pumpkin == null:
		print("No pumpkin assigned")
	else:
		pumpkin.process_mode = Node.PROCESS_MODE_DISABLED

func interact() -> void:
	if Global.is_present:
		return
	
	if Global.player.current_item is Seed:
		var seed_item: Seed = Global.player.current_item as Seed
		
		if seed_item.plant_type == "vines":
			if vines == null:
				return
		if seed_item.plant_type == "maple_tree":
			if maple_tree == null:
				return
		if seed_item.plant_type == "pumpkin":
			if pumpkin == null:
				return
		
		seed_item.queue_free()
		
		var seed_scene: PackedScene = load(seed_item.scene_file_path);
		var new_seed: Seed = seed_scene.instantiate();
		new_seed.planted = true
		planted = true
		add_child(new_seed)
		seed = new_seed
		Global.player.current_item = null
		
		match seed.plant_type:
			"vines":
				plant = vines
			"maple_tree":
				plant = maple_tree
			"pumpkin":
				plant = pumpkin
		audio_stream_player_sfx.stream = plant_sound
		audio_stream_player_sfx.play()

func on_change_to_present() -> void:
	if !planted:
		return
	plant.process_mode = Node.PROCESS_MODE_INHERIT
	plant.visible = true
	seed.visible = false

func on_change_to_past() -> void:
	if !planted:
		return
	plant.process_mode = Node.PROCESS_MODE_DISABLED
	plant.visible = false
	seed.visible = true
