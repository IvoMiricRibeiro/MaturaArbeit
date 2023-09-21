extends Control

var sphere = preload("res://Sphere.tscn")
onready var camera = get_node("/root/Spatial/CameraBody")
var SelectedBody
var TimeStopped = true
var GravityExists = false

var DefaultElas = false
var DefaultRad = 1
var DefaultFric = 0.2
var DefaultMass = 1

func _physics_process(delta):
	if Input.is_action_just_pressed("letter_e"):
		create()
	if Input.is_action_just_pressed("letter_t"):
		TimeStopped = !TimeStopped
	if Input.is_action_just_pressed("letter_g"):
		GravityExists = !GravityExists
		

func create():
	var sphereinstance = sphere.instance()
	sphereinstance.translation = Vector3(camera.translation.x, camera.translation.y, camera.translation.z)-(camera.global_transform.basis.z*2)
	sphereinstance.Elastic = DefaultElas
	sphereinstance.Radius = DefaultRad
	sphereinstance.Mass = DefaultMass
	sphereinstance.Friction = DefaultFric
	add_child(sphereinstance)
