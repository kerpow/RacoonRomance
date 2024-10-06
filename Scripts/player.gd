class_name Player
extends CharacterBody2D

@export var max_stamina : float = 10
@export var stamina : float = 10
@export var stamina_refill_speed : float = 5
@export var stamina_refill_delay : float = 2
@export var stamina_refill_time_passed : float = 0

@export var WalkSpeed = 200
@export var SprintMultiplier = 2
@export var SneakMultiplier = .5

@export var SoundRadius = 100
@export var SoundAmount = 20
@export var SprintSoundMultiplier = 2
@export var SneakSoundMultiplier = .5


@onready var sprite_2d: Sprite2D = $Sprite2D


@onready var sound_particles: GPUParticles2D = $SoundParticles

@export var is_hidden = false

#var target_trash_can : TrashCan
		
		
func _ready() -> void:
	Events.player_stamina_update.emit(stamina, max_stamina)
	
#func player_next_to_trash ( trash : TrashCan):
	#target_trash_can = trash
	#
#func _process(delta: float) -> void:
	#if target_trash_can != null and Input.is_action_just_pressed("rummage"):
		#target_trash_can.rummage()

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_vector("left", "right","up","down")
	var speed = WalkSpeed
	
	sound_particles.process_material.emission_ring_inner_radius = SoundRadius
	sound_particles.amount_ratio = 1
	if Input.is_action_pressed("sneak"):
		speed *= SneakMultiplier
		sound_particles.process_material.emission_ring_inner_radius = SoundRadius * SneakSoundMultiplier
		sound_particles.amount_ratio = SneakSoundMultiplier
		refill_stamina(delta)
	elif Input.is_action_pressed("sprint") and stamina > 0:
		stamina -= delta
		speed *= SprintMultiplier
		sound_particles.process_material.emission_ring_inner_radius = SoundRadius * SprintSoundMultiplier
		sound_particles.amount_ratio = SprintSoundMultiplier
		use_stamina(delta)
	else:
		refill_stamina(delta)
	sound_particles.process_material.emission_ring_radius = sound_particles.process_material.emission_ring_inner_radius + 10

	correct_facing(direction)	

	velocity = direction * speed 


	if velocity.length() > 0:
		sound_particles.set_emitting(true)
	else:
		sound_particles.set_emitting(false)
		
	move_and_slide()
	
func correct_facing(direction : Vector2):
	
	if direction.x > 0 and sprite_2d.scale.x == 1:
		var tween = get_tree().create_tween()
		tween.tween_property(sprite_2d, "scale", Vector2(-1,1), .1)
	elif direction.x < 0 and sprite_2d.scale.x == -1:
		var tween = get_tree().create_tween()
		tween.tween_property(sprite_2d, "scale", Vector2(1,1), .1)
	
func use_stamina(delta : float):
	
	stamina -= delta
	stamina_refill_time_passed = 0
	Events.player_stamina_update.emit(stamina, max_stamina)
	
func refill_stamina(delta :float):
	if stamina_refill_time_passed < stamina_refill_delay:
		stamina_refill_time_passed += delta
	elif stamina < max_stamina:
		stamina += delta * stamina_refill_speed
		Events.player_stamina_update.emit(stamina, max_stamina)
	
func _on_area_2d_body_entered(body: Node2D) -> void:
	#if body is Human:
		#body.alert_with(self)
		#
	pass
