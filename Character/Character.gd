extends KinematicBody2D

export var max_speed := 500.0
var current_speed := 0.0
var target_speed := 0.0

var movement_direction := Vector2.ZERO
var inertial_direction := Vector2.ZERO

var horiz_heading: float
var vert_heading: float

enum HeadingDirections {RIGHT, LEFT, UP, DOWN}
var heading_direction = HeadingDirections.DOWN
var current_heading = HeadingDirections.UP  # Used to catch if there is a change
var heading_change := false

enum States {MOVING, STATIC}

# Get nodes

export (NodePath) onready var body_sprite = get_node(body_sprite)
export (NodePath) onready var body_animator = get_node(body_animator)
export (NodePath) onready var weapon_sprite = get_node(weapon_sprite)
export (NodePath) onready var weapon_animator = get_node(weapon_animator)


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	# Connect signals
	SignalBus.connect("character_heading_changed", self, "_adjust_sprites")


func _process(delta: float) -> void:
	weapon_sprite.rotation = (weapon_sprite.global_position - get_global_mouse_position()).angle()
	
	# Determine if heading changes
		

func _physics_process(delta: float) -> void:
	_move_char(delta)
	_get_direction()
	
	
func _move_char(delta: float) -> void:
	movement_direction = Input.get_vector("left", "right", "up", "down").normalized()
	
	if abs(movement_direction.x) < 0.01 and abs(movement_direction.y) < 0.01:
		target_speed = 0.0
	else:
		target_speed = max_speed
		inertial_direction = movement_direction
		
		
	current_speed = lerp(current_speed, target_speed, 0.5)
	move_and_slide(current_speed * inertial_direction)


func _get_direction():
	current_heading = heading_direction  # Cache to see if there is a change
	horiz_heading = inertial_direction.dot(Vector2(1, 0))
	vert_heading = inertial_direction.dot(Vector2(0, 1))
	
	# Prioritise U/D
	if horiz_heading < -0.5:
		heading_direction = HeadingDirections.LEFT
	elif horiz_heading > 0.5:
		heading_direction = HeadingDirections.RIGHT
	elif vert_heading < -0.5:
		heading_direction = HeadingDirections.UP
	elif vert_heading > 0.5:
		heading_direction = HeadingDirections.DOWN
		
	if current_heading != heading_direction:
		SignalBus.emit_signal("character_heading_changed", heading_direction)
		print("SETTING HEADING TO: ", heading_direction)


func _adjust_sprites(new_dir):
	if new_dir == HeadingDirections.RIGHT:
		body_animator.play("RightWalk")
	elif new_dir == HeadingDirections.LEFT:
		body_animator.play("LeftWalk")
	elif new_dir == HeadingDirections.UP:
		body_animator.play("BackWalk")
	elif new_dir == HeadingDirections.DOWN:
		body_animator.play("ForwardWalk")
		
