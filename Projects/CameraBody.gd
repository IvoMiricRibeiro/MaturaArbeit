extends KinematicBody

# Movement variables
var speed = 25
var direction = Vector3()

onready var camera = $Camera

var mouse_sensitivity = 0.1

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	direction = Vector3()
	if Input.is_action_pressed("move_forward"):
		direction -= transform.basis.z
	if Input.is_action_pressed("move_backward"):
		direction += transform.basis.z
	if Input.is_action_pressed("move_left"):
		direction -= transform.basis.x
	if Input.is_action_pressed("move_right"):
		direction += transform.basis.x
	if Input.is_action_pressed("move_down"):
		direction -= transform.basis.y
	if Input.is_action_pressed("move_up"):
		direction += transform.basis.y
	
	if Input.is_action_pressed("look_right"):
		rotate_y(deg2rad(-3))
	if Input.is_action_pressed("look_left"):
		rotate_y(deg2rad(3))
	if Input.is_action_pressed("look_up"):
		if camera.rotation_degrees.x < 84:
			camera.rotate_x(deg2rad(3))
	if Input.is_action_pressed("look_down"):
		if camera.rotation_degrees.x > -84:
			camera.rotate_x(deg2rad(-3))
	
	direction = direction.normalized()
	move_and_slide(direction*speed)
