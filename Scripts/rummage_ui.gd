class_name RummageUI
extends Control

@onready var target_progress: TextureProgressBar = $TargetProgress
@onready var moving_progress: TextureProgressBar = $MovingProgress
@onready var overall_progress: TextureProgressBar = $OverallProgress

@export var moving_color : Color
@export var moving_color_good : Color

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	modulate = Color.TRANSPARENT
	Events.rummage_begin.connect(on_rummage_begin)
	Events.rummage_end.connect(on_rummage_end)
	Events.rummage_success.connect(on_rummage_success)
	Events.rummage_update.connect(on_rummage_update)
	
func on_rummage_begin(can : TrashCan):
	var tween = get_tree().create_tween()
	tween.tween_property(self, "modulate", Color.WHITE, .25)
	target_progress.value = can.min_range
	moving_progress.value = 0
	overall_progress.max_value = can.successes_required
	overall_progress.value = can.successes
	
func on_rummage_end(can : TrashCan):
	var tween = get_tree().create_tween()
	tween.tween_property(self, "modulate", Color.TRANSPARENT, .25)
	
	
func on_rummage_success(can : TrashCan):
	var tween = get_tree().create_tween()
	tween.tween_property(self, "modulate", Color.TRANSPARENT, .25)

func on_rummage_update(can : TrashCan):
	moving_progress.value = can.input
	
	target_progress.value = can.min_range
	if can.input > can.min_range:
		moving_progress.tint_progress = moving_color_good
	else:
		moving_progress.tint_progress = moving_color
		
	var tween = get_tree().create_tween()
	tween.tween_property(overall_progress, "value", can.successes, .25)
