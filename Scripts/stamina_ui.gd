extends TextureProgressBar

@onready var shinys: Label = $"../Shinys"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Events.player_stamina_update.connect(on_player_stamina_update)
	

func on_player_stamina_update(current : float, max : float):
	max_value = max
	value = current
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
