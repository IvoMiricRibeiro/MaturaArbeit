extends KinematicBody

var Velocity = Vector3() setget VSet , VGet 
var Acceleration = Vector3() setget ASet, AGet
var Mass = 1 setget MSet, MGet

var Elastic = true

var OuterForces = [] #List with the force of gravity and forces of other objects
var InnerForce = Vector3() #Force calculated with the "real" acceleration
var ResForce = Vector3() #Sum of all forces

var CollidedOnce = false setget CollideSet , CollideGet
var AgainstX = false
var AgainstY = false
var AgainstZ = false

onready var Controler = get_parent()

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

#Setters and Getter functions
func VSet(param):
	print("Setting param: ", param)
	Velocity = param
func VGet():
	return Velocity

func ASet(param):
	Acceleration = param
func AGet():
	return Acceleration

func MSet(param):
	Mass = param
func MGet():
	return Mass

func CollideSet(param1):
	CollidedOnce = param1
func CollideGet():
	return CollidedOnce

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	#Time stopping code
	if Controler.TimeStopped == false:
		for index in get_slide_count():
			var collider = get_slide_collision(index).collider
			#Code for other Kinematic Bodies
			if collider is KinematicBody:
				if CollideGet() == false:
					CollideSet(true)
					collider.CollideSet(true)
					#Useful variables
					var V1 = self.VGet()
					var V2 = collider.VGet()
					var M1 = self.MGet()
					var M2 = collider.MGet()
					#Code for elastic collisions
					if Elastic == true and collider.Elastic == true:
						var PD1 = self.translation-collider.translation
						var PD2 = collider.translation-self.translation
						var V1n = V1-(((2*M2)/(M1+M2))*(((Vector3(V1-V2).dot(PD1))/(PD1.length()*PD1.length()))*PD1))
						var V2n = V2-(((2*M1)/(M1+M2))*(((Vector3(V2-V1).dot(PD2))/(PD2.length()*PD2.length()))*PD2))
						VSet(V1n)
						collider.VSet(V2n)
					#Inelastic collisions here
					if Elastic == false and collider.Elastic == false:
						var Vn = ((M1*V1)+(M2*V2))/(M1+M2)
						VSet(Vn)
						collider.VSet(Vn)
			if collider is StaticBody:
				if Elastic == true:
					var V = self.VGet()
					var A = self.AGet()
					if collider.collision_layer == 1:
						VSet(Vector3(-V.x, V.y, V.z))
						#ASet(Vector3(-A.x, A.y, A.z))
					if collider.collision_layer == 2:
						VSet(Vector3(V.x, -V.y, V.z))
						#ASet(Vector3(A.x, -A.y, A.z))
					if collider.collision_layer == 4:
						VSet(Vector3(V.x, V.y, -V.z))
						#ASet(Vector3(A.x, A.y, -A.z))
				#if Elastic == false:
				#	if collider.collision_layer == 1:
				#		pass
				#	if collider.collision_layer == 2:
				#		pass
				#	if collider.collision_layer == 4:
				#		pass
				
		VSet(VGet()+(AGet()/60))
		InnerForce = Acceleration*Mass
		for j in OuterForces.size():
			ResForce += OuterForces[j]
	
		move_and_slide(self.VGet())
		InnerForce = Vector3()
		ResForce = Vector3()
	
#From https://www.youtube.com/watch?v=U5qGj8qt7VU
func _on_Sphere_input_event(camera, event, position, normal, shape_idx):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and event.pressed == true:
			Controler.SelectedBody = self
		if event.button_index == BUTTON_RIGHT and event.pressed == true:
			if Controler.TimeStopped == false:
				Controler.TimeStopped = true
			Controler.SelectedBody = self
