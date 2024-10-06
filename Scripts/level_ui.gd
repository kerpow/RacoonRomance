extends CanvasLayer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Events.game_level_closing.connect(on_game_level_closing)

func on_game_level_closing():
	visible = false
