class_name TrashCan
extends Node2D

@onready var upright: Sprite2D = $Upright
@onready var toppled: Sprite2D = $Toppled
@onready var dust: Sprite2D = $Dust

var rummaging = false
var input : float = 0
var direction : float = 1
var speed : float = 80
var min_range : float = 80
var min_range_start : float = 60
var min_range_progress : float = 15

var is_toppled : bool = false

var successes = 0
@export var successes_required : int  = 3
var dust_rotation_speed : float = 100


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	dust.modulate = Color.TRANSPARENT
	toppled.modulate = Color.TRANSPARENT
	



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if rummaging:
		dust.rotation_degrees += dust_rotation_speed * delta
		input += direction * delta * speed
		if input > 100:
			input = 100
			direction = -1
		if input < 0:
			input = 0
			direction = 1

		if Input.is_action_just_pressed("rummage"):
			if input > min_range:
				successes += 1
				min_range += min_range_progress
				if successes >= successes_required:
					Events.player_shiny_collected.emit()
					Events.rummage_success.emit(self)
					succeed_topple();
			else:
				successes = 0
				min_range = min_range_start
				Events.rummage_fail.emit(self)
			input = 0
				
		Events.rummage_update.emit(self)

func _on_area_2d_body_entered(body: Node2D) -> void:
	if !is_toppled and body is Player:
		Events.rummage_begin.emit(self)
		rummaging = true
		min_range = min_range_start
		
		var tween = get_tree().create_tween()
		tween.tween_property(dust, "modulate", Color.WHITE, .1)


func _on_area_2d_body_exited(body: Node2D) -> void:
	if body is Player:
		Events.rummage_end.emit(self)
		rummaging = false
		
		var tween = get_tree().create_tween()
		tween.tween_property(dust, "modulate", Color.TRANSPARENT, .1)
		
func succeed_topple():
	is_toppled = true
	
	
	var tween = get_tree().create_tween()
	tween.tween_property(upright, "modulate", Color.TRANSPARENT, .01)
	tween.tween_property(toppled, "modulate", Color.WHITE, .01)
	tween.tween_property(dust, "modulate", Color.TRANSPARENT, .1)
