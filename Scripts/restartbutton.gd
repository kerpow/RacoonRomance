extends Button


func _pressed() -> void:
	Events.game_request_restart_game.emit()
