extends Node2D

var shinies_required : int
var shinies_acquired : int = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Events.player_shiny_collected.connect(on_player_shiny_collected)
	Events.player_caught.connect(on_player_caught)
	Events.player_at_spawn.connect(on_player_at_spawn)
	
	shinies_required = get_tree().get_nodes_in_group("trash_can").size()
	
	Events.shineys_updated.emit(shinies_acquired, shinies_required)
	
func on_player_at_spawn():
	if shinies_acquired >= shinies_required:
		Events.game_request_next_level.emit()
	
func on_player_shiny_collected():
	shinies_acquired += 1
	Events.shineys_updated.emit(shinies_acquired, shinies_required)

func on_player_caught():
	Events.game_request_lose_scene.emit()

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("win"):
		Events.game_request_next_level.emit()
	
