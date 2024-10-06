extends Node2D

@export var levels : Array[PackedScene]

@export var lose_scene : PackedScene

@export var current_level = 0
var current_scene : Node2D


@onready var fade: ColorRect = $CanvasLayer/Fade
@onready var racoon: Sprite2D = $CanvasLayer/Racoon


var next_scene : PackedScene
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Events.game_request_next_level.connect(on_game_request_next_level)
	Events.game_request_lose_scene.connect(on_game_request_lose_scene)
	Events.game_request_restart_level.connect(on_game_request_restart_level)
	Events.game_request_restart_game.connect(on_game_request_restart_game)
	
	load_level(current_level)
	
func on_game_request_restart_game():
	load_level(0)
	
func on_game_request_next_level():
	load_level(current_level + 1)
	
	
func on_game_request_restart_level():
	load_level(current_level)
	
func on_game_request_lose_scene():
	load_scene(lose_scene)

func load_level(index : int):
	current_level = index
	load_scene(levels[index])
	

func load_scene(new_scene : PackedScene):
	
	Events.game_level_closing.emit()
	next_scene = new_scene
	var tween = get_tree().create_tween()
	racoon.position = Vector2(-100, 550)
	tween.tween_property(fade, "modulate", Color.WHITE, .5)
	tween.tween_property(racoon, "position", Vector2(1245, 540), .5)
	tween.tween_callback(swap_scenes)
	tween.tween_property(fade, "modulate", Color.TRANSPARENT, .5)
	

	
func swap_scenes():
	var scene = next_scene.instantiate()
	
	add_child(scene)
	
	if current_scene != null:
		current_scene.queue_free()	
	
	current_scene = scene
