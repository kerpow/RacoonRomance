class_name Human
extends CharacterBody2D

@onready var alert_icon: Node2D = $"Alert Icon"

@onready var body: Sprite2D = $Body
@onready var head: Sprite2D = $Head

@export var head_color : Color
@export var body_color : Color

@export var speed = 100
@export var alert_speed_modifier = 1.5

@export var route: Line2D

@export var player_dark_vision_scale = 1
@export var player_lit_vision_scale = 2

@onready var nav_agent: NavigationAgent2D = $NavigationAgent2D
@onready var vision: Node2D = $Vision
@onready var vision_alert: Node2D = $VisionAlert
@onready var capture_area_2d: Area2D = $"Capture Area2d"

enum STATES {Init, Patrol, Investigate}
var state : STATES
var destination : Vector2

var route_point : int

var investigating_player : Player

@export var give_up_time : float = 5;
var investigating_time : float

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	body.modulate = body_color
	head.modulate = head_color
	route.visible = false
	alert_icon.modulate = Color.TRANSPARENT
	
	Events.player_light_change.connect(player_light_change)
	Events.player_hidden.connect(on_player_hidden)
	
func on_player_hidden():
	change_state(STATES.Patrol)
	
func player_light_change(illuminated : bool):
	if illuminated:
		vision.visible = false
		vision_alert.visible = true
	else:
		vision.visible = true
		vision_alert.visible = false
	
func begin_patrol():	
	var closest_distance : float
	var closest_point : Vector2
		
	for x in route.points.size():
		var p = route.points[x]
		var distance =  position.distance_squared_to(p)
		if distance < closest_distance   || closest_distance == 0:
			closest_distance = distance
			closest_point = p
			route_point = x
			
	nav_agent.target_position = closest_point
	
	state = STATES.Patrol
	
func next_patrol():
	route_point += 1
	if route_point == route.points.size():
		route_point = 0
		
	nav_agent.target_position = route.points[route_point]
	

func _physics_process(_delta: float) -> void:
	if state == STATES.Init:
		begin_patrol()
		return
		
	if nav_agent.is_navigation_finished():
		if state == STATES.Patrol:
			next_patrol()
		return
		
	if state == STATES.Investigate:
		move_to_investigate()
		velocity = global_position.direction_to(nav_agent.get_next_path_position()) * speed * alert_speed_modifier
	else:
		velocity = global_position.direction_to(nav_agent.get_next_path_position()) * speed;
		
	move_and_slide()

func _process(delta: float) -> void:
	vision.global_position = vision.global_position.lerp(global_position +  velocity.normalized() * 200, delta * 2)
	vision_alert.global_position = vision_alert.global_position.lerp(global_position +  velocity.normalized() * 200, delta * 2)


	if state == STATES.Investigate:
		investigating_time += delta
		if investigating_time > give_up_time:
			change_state(STATES.Patrol)
		

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is Player and !body.is_hidden:
		alert_with(body)
		
func _on_area_2d_body_entered_alert(body: Node2D) -> void:
	if vision_alert.visible and body is Player and !body.is_hidden:
		alert_with(body)

func alert_with(player : Player):
	investigating_player = player
	change_state(STATES.Investigate)

func move_to_investigate():
	if !investigating_player.is_hidden:
		nav_agent.target_position = investigating_player.global_position
	
func change_state(s : STATES):
	if s == STATES.Patrol:
		Events.human_alert_end.emit()
		var tween = get_tree().create_tween()
		tween.tween_property(alert_icon, "modulate", Color.TRANSPARENT, .25)
		next_patrol()
	elif s== STATES.Investigate:
		Events.human_alert_begin.emit()
		investigating_time = 0
		var tween = get_tree().create_tween()
		tween.tween_property(alert_icon, "modulate", Color.WHITE, .25)
		move_to_investigate()
		
	state = s


func _on_capture_area_2d_body_entered(body: Node2D) -> void:
	if body is Player and !body.is_hidden:
		Events.player_caught.emit();
		
