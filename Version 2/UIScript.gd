extends Control

onready var Selected = get_parent().SelectedBody

onready var Vel = $Velocity
onready var VxS = $Velocity/VxSlide
onready var VyS = $Velocity/VySlide
onready var VzS = $Velocity/VzSlide
onready var Vx = $Velocity/Vx
onready var Vy = $Velocity/Vy
onready var Vz = $Velocity/Vz
onready var VS = $Velocity/VSet

onready var Acc = $Acceleration
onready var AxS = $Acceleration/AxSlide
onready var AyS = $Acceleration/AySlide
onready var AzS = $Acceleration/AzSlide
onready var Ax = $Acceleration/Ax
onready var Ay = $Acceleration/Ay
onready var Az = $Acceleration/Az
onready var AS = $Acceleration/ASet

onready var M = $Mass
onready var MSl = $Mass/MSlide
onready var MV = $Mass/MVal
onready var MSet = $Mass/MSet

onready var R = $Radius
onready var RSl = $Radius/RSlide
onready var RV = $Radius/RVal
onready var RSet = $Radius/RSet

onready var Warudo = $Time

func _physics_process(delta):
	Selected = get_parent().SelectedBody
	if Selected != null:
		Vel.text = "Current velocity: "+str(Selected.Velocity)
		Vx.text = "v.x: "+str(VxS.value)
		Vy.text = "v.y: "+str(VyS.value)
		Vz.text = "v.z: "+str(VzS.value)
		
		Acc.text = "Current acceleration: "+str(Selected.Acceleration)
		Ax.text = "a.x: "+str(AxS.value)
		Ay.text = "a.y: "+str(AyS.value)
		Az.text = "a.z: "+str(AzS.value)
		
		M.text = "Current mass: "+str(Selected.Mass)
		MV.text = "m: "+str(MSl.value)
		
		R.text = "Current radius: "+str(Selected.scale.x)
		RV.text = "r: "+str(RSl.value)
		
		Warudo.text = "Time stopped?: "+str(get_parent().TimeStopped)
		
func _on_VSet_pressed():
	Selected.VSet(Vector3(VxS.value, VyS.value, VzS.value))

func _on_ASet_pressed():
	Selected.ASet(Vector3(AxS.value, AyS.value, AzS.value))

func _on_MSet_pressed():
	Selected.MSet(MSl.value)

func _on_RSet_pressed():
	Selected.scale = Vector3(RSl.value, RSl.value, RSl.value)
