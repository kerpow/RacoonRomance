extends Label


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	modulate = Color.TRANSPARENT
	Events.shineys_updated.connect(on_shineys_updated)

func on_shineys_updated(current, max):
	if current == 0:
		text = "Rummage trash cans for shiny things."
	elif current < max:
		text = "Rummage more trash cans."
	else:
		text = "Go back to your tree."
		
	var tween = get_tree().create_tween()
	tween.tween_property(self, "modulate", Color.WHITE, .2)
	tween.tween_property(self, "scale", Vector2(1.1,1.1), 1)
	tween.tween_property(self, "scale", Vector2(1,1), 1)
	tween.tween_property(self, "scale", Vector2(1.1,1.1), 1)
	tween.tween_property(self, "modulate", Color.TRANSPARENT, .2)
		
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
