extends KinematicBody

var Velocity = Vector3() setget VSet
var Acceleration = Vector3() setget ASet

var Mass = 1 setget MSet
var Friction = 0.2
var Elastic = false
var Radius = 1

var InnerForce = Vector3() #Force calculated with the "real" acceleration
var NormalForce = Vector3()
var FricForce = Vector3()
var ResForce = Vector3() #Sum of all forces

var AgainstSurface = [false, false, false] setget ASurfSet
var CanAccelerate = true

onready var Controler = get_parent()
onready var CMesh = $CSGMesh

#Setters functions for other bodies
func VSet(param):
	Velocity = param
func ASet(param):
	Acceleration = param
func MSet(param):
	Mass = param
func ASurfSet(param):
	AgainstSurface = param

func _ready():
	scale = Vector3(Radius, Radius, Radius)

func _process(delta):
	if Controler.SelectedBody == self:
		CMesh.material.next_pass.set_shader_param("border_width", 0.1) #Nicely taken from the 3.5 docs
	else:
		CMesh.material.next_pass.set_shader_param("border_width", 0)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	#Time stopping code
	if Controler.TimeStopped == false:
		#Acceleration, gravity, and forces
		InnerForce = Acceleration*Mass
		if CanAccelerate == true:
			VSet(Velocity+(Acceleration/60))
			if Controler.GravityExists == true:
				VSet(Velocity+(Vector3(0, -9.81, 0)/60))
				InnerForce += Vector3(0,-9.81,0)*Mass
		ResForce = InnerForce-FricForce
		
		move_and_slide(self.Velocity)
		
		AgainstSurface = [false, false, false]
		
		#Collisions
		for index in get_slide_count():
			var body = get_slide_collision(index).collider
			if body is KinematicBody:
				#Useful variables
				var V1 = Velocity
				var V2 = body.Velocity
				var V1n
				var V2n
				var M1 = Mass
				var M2 = body.Mass
				var PD1 = translation-body.translation
				var PD2 = -PD1
				#Code for inelastic collisions
				if Elastic == false and body.Elastic == false:
					V1n = ((M1*V1)+(M2*V2))/(M1+M2)
					V2n = V1n
					if AgainstSurface != body.AgainstSurface:
						if AgainstSurface > body.AgainstSurface:
							body.ASurfSet(AgainstSurface)
						else:
							ASurfSet(body.AgainstSurface)
				# Elsatic and "half elastic" collisions
				else:
					V1n = V1-(((2*M2)/(M1+M2))*(((Vector3(V1-V2).dot(PD1))/(PD1.length()*PD1.length()))*PD1))
					V2n = V2-(((2*M1)/(M1+M2))*(((Vector3(V2-V1).dot(PD2))/(PD2.length()*PD2.length()))*PD2))
					if (Elastic and not body.Elastic) or (not Elastic and body.Elastic):
						V1n = V1n/2
						V2n = V2n/2
				VSet(V1n)
				body.VSet(V2n)
				
			if body is StaticBody:
				var surface = 0
				var dis = self.translation-body.translation
				CanAccelerate = false
				var Vl = Velocity
				while surface < 3:
					if body.get_collision_layer_bit(surface) == true:
						if Elastic == true:
							Vl[surface] = -Vl[surface]
						elif (Elastic == false) and (Velocity[surface]*dis[surface] <= 0):
							Vl[surface] = 0
							AgainstSurface[surface] = true
							NormalForce[surface] = Acceleration[surface]
							if surface == 1:
								NormalForce += Vector3(0,9.81,0)
					surface += 1
				NormalForce = NormalForce*Mass
				VSet(Vl)
				FricForce = (Velocity.normalized()*NormalForce.length()*Friction)
				
				var Vf = (FricForce/(Mass*60))
				if Velocity.length()-Vf.length() < 0:
					VSet(Vector3())
				else:
					VSet(Velocity-(FricForce/(Mass*60)))
				
		var Vn = Velocity
		for side in AgainstSurface.size():
			if AgainstSurface[side] == true:
				Vn[side] = 0
		VSet(Vn)
		
		NormalForce = Vector3()
		CanAccelerate = true
		
		
#From https://www.youtube.com/watch?v=U5qGj8qt7VU
func _on_Sphere_input_event(camera, event, position, normal, shape_idx):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and event.pressed == true:
			Controler.SelectedBody = self
		if event.button_index == BUTTON_RIGHT and event.pressed == true:
			if Controler.TimeStopped == false:
				Controler.TimeStopped = true
			Controler.SelectedBody = self
