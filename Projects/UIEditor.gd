extends Control

onready var BAVC = get_parent()
onready var Selected = BAVC.SelectedBody

onready var VxTitle = $Vx
onready var VyTitle = $Vy
onready var VzTitle = $Vz
onready var VxValue = $VxValue
onready var VyValue = $VyValue
onready var VzValue = $VzValue

onready var AxTitle = $Ax
onready var AyTitle = $Ay
onready var AzTitle = $Az
onready var AxValue = $AxValue
onready var AyValue = $AyValue
onready var AzValue = $AzValue

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _process(delta):
	VxTitle.text = "Velocity.x: "+str(VxValue.value)+"m/s"
	VyTitle.text = "Velocity.y: "+str(VyValue.value)+"m/s"
	VzTitle.text = "Velocity.z: "+str(VzValue.value)+"m/s"
	
	AxTitle.text = "Acceleration.x: "+str(AxValue.value)+"m/s²"
	AyTitle.text = "Acceleration.y: "+str(AyValue.value)+"m/s²"
	AzTitle.text = "Acceleration.z: "+str(AzValue.value)+"m/s²"
	
	if Input.is_action_just_pressed("letter_r"):
		Selected = BAVC.SelectedBody
		BAVC.add_velocity(Selected, Vector3(VxValue.value, VyValue.value, VzValue.value))
	if Input.is_action_just_pressed("letter_f"):
		Selected = BAVC.SelectedBody
		BAVC.add_acceleration(Selected, Vector3(AxValue.value, AyValue.value, AzValue.value))
