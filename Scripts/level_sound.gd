extends Node2D
@onready var music: AudioStreamPlayer = $Music
@onready var run: AudioStreamPlayer = $Run
@onready var rummage: AudioStreamPlayer = $Rummage
@onready var alert: AudioStreamPlayer = $Alert


var alerts : int = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print("Playing sound")
	music.play()
	Events.human_alert_begin.connect(on_human_alert_begin)
	Events.human_alert_end.connect(on_human_alert_end)
	Events.player_move_begin.connect(on_player_move_begin)
	Events.player_move_end.connect(on_player_move_end)
	Events.rummage_begin.connect(on_rummage_begin)
	Events.rummage_end.connect(on_rummage_end)
	Events.player_hidden.connect(on_plyayer_hidden)

func on_player_move_begin():
	run.play()
	
func on_player_move_end():
	run.stop()
	
func on_rummage_begin(_trashCan):
	rummage.play()
	
func on_rummage_end(_trashCan):
	rummage.stop()


func on_human_alert_begin():
	alerts += 1
	if !alert.playing: 
		alert.play()
		
func on_human_alert_end():
	alerts -= 1
	if alerts < 0:
		alerts = 0 
	if alerts == 0:
		alert.stop()

func on_plyayer_hidden():
	alerts = 0
	alert.stop()
