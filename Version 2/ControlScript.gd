extends Control

var sphere = preload("res://Sphere.tscn")
onready var camera = get_node("/root/Spatial/CameraBody")
var SelectedBody
var TimeStopped = true
var GravityExists = false

func _physics_process(delta):
	if Input.is_action_just_pressed("letter_e"):
		create()
	if Input.is_action_just_pressed("letter_t"):
		timechange()
	if Input.is_action_just_pressed("letter_g"):
		gravitychange()
		
func timechange():
	TimeStopped = !TimeStopped
	
func gravitychange():
	GravityExists = !GravityExists

func create():
	var sphereinstance = sphere.instance()
	sphereinstance.translation = Vector3(camera.translation.x, camera.translation.y-1.5, camera.translation.z)
	add_child(sphereinstance)
