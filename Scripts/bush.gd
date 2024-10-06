extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is Player:
		Events.player_hidden.emit()
		body.is_hidden = true
	


func _on_area_2d_body_exited(body: Node2D) -> void:
	if body is Player:
		body.is_hidden = false
