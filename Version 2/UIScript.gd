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

onready var F = $Force

onready var M = $Mass
onready var MSl = $Mass/MSlide
onready var MV = $Mass/MVal
onready var MSet = $Mass/MSet

onready var R = $Radius
onready var RSl = $Radius/RSlide
onready var RV = $Radius/RVal
onready var RSet = $Radius/RSet

onready var Fr = $Friction
onready var FrSl = $Friction/FSlide
onready var FrV = $Friction/FVal
onready var FrSet = $Friction/FSet

onready var Elas = $Elasticity

#onready var Warudo = $Time
#onready var Clock = $Clock
#onready var Rabbity = $Gravity
#onready var Arrow = $Arrow

onready var Instr = $Instructions

func _physics_process(delta):
	Selected = get_parent().SelectedBody
		
	#Warudo.text = "Time stopped?: "+str(get_parent().TimeStopped)
	#Rabbity.text = "Gravity: "+str(get_parent().GravityExists)
	#Clock.visible = !get_parent().TimeStopped
	#Arrow.visible = get_parent().GravityExists
	
	
	if Instr.get_child(0).visible == true:
			Instr.text = "Click here to hide controls"
	if Instr.get_child(0).visible == false:
			Instr.text = "Click here to show controls"
	
	if Selected != null:
		Vel.text = "Current velocity: "+str(Selected.Velocity)+" m/s"
		Vx.text = "v.x: "+str(VxS.value)
		Vy.text = "v.y: "+str(VyS.value)
		Vz.text = "v.z: "+str(VzS.value)
		
		Acc.text = "Current acceleration: "+str(Selected.Acceleration)+ " m/s²"
		Ax.text = "a.x: "+str(AxS.value)
		Ay.text = "a.y: "+str(AyS.value)
		Az.text = "a.z: "+str(AzS.value)
		
		F.text = "Resultant force: "+str(Selected.ResForce)+ " N"
		
		M.text = "Current mass: "+str(Selected.Mass)+ " Kg"
		MV.text = "m: "+str(MSl.value)
		
		R.text = "Current radius: "+str(Selected.scale.x)+ " m"
		RV.text = "r: "+str(RSl.value)
		
		Fr.text = "Current coefficient of friction: "+str(Selected.Friction)
		FrV.text = "fr: "+str(FrSl.value)
		
		Elas.text = "Elastic?: "+str(Selected.Elastic)
			

func _on_VSet_pressed():
	if Selected != null:
		Selected.VSet(Vector3(VxS.value, VyS.value, VzS.value))

func _on_VSet0_pressed():
	if Selected != null:
		Selected.VSet(Vector3())
		VxS.value = 0
		VyS.value = 0
		VzS.value = 0

func _on_ASet_pressed():
	if Selected != null:
		Selected.ASet(Vector3(AxS.value, AyS.value, AzS.value))

func _on_ASet0_pressed():
	if Selected != null:
		Selected.ASet(Vector3())
		AxS.value = 0
		AyS.value = 0
		AzS.value = 0

func _on_MSet_pressed():
	if Selected != null:
		Selected.MSet(MSl.value)

func _on_MDef_pressed():
	get_parent().DefaultMass = MSl.value
	
func _on_RSet_pressed():
	if Selected != null:
		Selected.scale = Vector3(RSl.value, RSl.value, RSl.value)

func _on_RDef_pressed():
	get_parent().DefaultRad = RSl.value

func _on_FSet_pressed():
	if Selected != null:
		Selected.Friction = FrSl.value
	
func _on_FDef_pressed():
	get_parent().DefaultFric = FrSl.value

func _on_ESet_pressed():
	if Selected != null:
		Selected.Elastic = !Selected.Elastic

func _on_EDef_pressed():
	if Selected != null:
		get_parent().DefaultElas = Selected.Elastic

func _on_Quit_pressed():
	get_tree().quit()

func _on_Instructions_pressed():
	Instr.get_child(0).visible = !Instr.get_child(0).visible
