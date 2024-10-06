extends Label


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Events.shineys_updated.connect(on_shineys_updated)

func on_shineys_updated(current, max):
	text = str("Shiny Things " , current , " / " , max)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
