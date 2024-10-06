extends Node2D

@onready var area_2d: Area2D = $Area2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	area_2d.body_entered.connect(body_entered)
	area_2d.body_exited.connect(body_exited)
	pass # Replace with function body.

func body_entered(body : Node2D):
	if body is Player:
		Events.player_light_change.emit(true)
		
func body_exited(body : Node2D):
	if body is Player:
		Events.player_light_change.emit(false)
	
