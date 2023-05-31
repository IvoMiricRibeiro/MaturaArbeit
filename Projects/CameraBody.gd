extends KinematicBody

# Movement variables
var speed = 10
var direction = Vector3()

#onready var camera = $Camera
var mouse_sensitivity = 0.1
# Called when the node enters the scene tree for the first time.
#func _ready():
#	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _input(event):
	if event is InputEventMouseMotion:
		rotate_x(deg2rad(-event.relative.y * mouse_sensitivity))
		rotate_y(deg2rad(-event.relative.x * mouse_sensitivity))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	direction = Vector3()
	
	if Input.is_action_pressed("forward"):
		direction -= transform.basis.z
	if Input.is_action_pressed("backward"):
		direction += transform.basis.z
	if Input.is_action_pressed("left"):
		direction -= transform.basis.x
	if Input.is_action_pressed("right"):
		direction += transform.basis.x
	if Input.is_action_pressed("down"):
		direction -= transform.basis.y
	if Input.is_action_pressed("up"):
		direction += transform.basis.y
			
	direction = direction.normalized()
	move_and_slide(direction*speed)
