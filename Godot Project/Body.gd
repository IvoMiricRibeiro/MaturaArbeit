extends KinematicBody

var Velocity = Vector3() setget VSet
var Acceleration = Vector3() setget ASet

var Mass = 1 setget MSet
var COR = 1
var Friction = 0.2
var Radius = 1

var InnerForce = Vector3() #Force calculated with the acceleration var
var NormalForce = Vector3()
var FricForce = Vector3()
var ResForce = Vector3() #Sum of all forces

var ElasColHappened = [false, false, false]
var CanAccelerate = true
var HasCollided = false setget HasColSet

onready var Controler = get_parent()
onready var CMesh = $CSGMesh


#Setters functions for other bodies
func VSet(param):
	Velocity = param
func ASet(param):
	Acceleration = param
func MSet(param):
	Mass = param
func HasColSet(param):
	HasCollided = param

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
		#Acceleration and Forces
		InnerForce = Acceleration*Mass
		VSet(Velocity+(Acceleration/60))
		if Controler.GravityExists == true:
			VSet(Velocity+(Vector3(0,-9.81,0)/60))
			InnerForce += Vector3(0,-9.81,0)*Mass
		ResForce = InnerForce-FricForce
		
		move_and_slide(Velocity)
		
		ElasColHappened = [false, false, false]
		#Collisions
		for index in get_slide_count():
			var body = get_slide_collision(index).collider
			if body is KinematicBody:
				if body.HasCollided == false:
					HasColSet(true)
					body.HasColSet(true)
					
					#Useful variables
					var V1 = Velocity
					var V2 = body.Velocity
					var M1 = Mass
					var M2 = body.Mass
					var PD1 = translation-body.translation
					var CorN = (COR+body.COR)/2
					
					var dV = (((1+CorN)*M2)/(M1+M2))*((Vector3(V1-V2).dot((PD1)))/PD1.length_squared())*PD1
					VSet(V1-dV)
					body.VSet(V2+dV)
					
				if body.HasCollided == true:
					body.HasColSet(false)
				HasColSet(false)
				
			if body is StaticBody:
				var axis = 0
				var dis = self.translation-body.translation
				while axis < 3:
					if body.get_collision_layer_bit(axis) == true:
						var Vn = Velocity[axis]
						if ElasColHappened[axis] == false:
							ElasColHappened[axis] = true
							Vn = -Velocity[axis]*COR
						if sqrt(Vn*Vn) < 0.5:
							Vn = 0
						Velocity[axis] = Vn
						if Vn == 0:
							NormalForce = -InnerForce
					axis += 1
				FricForce = (Velocity.normalized()*NormalForce.length()*Friction)
				ResForce = ResForce + NormalForce - FricForce
				
				var Vf = (FricForce/(Mass*60))
				if Velocity.length()-Vf.length() < 0:
					VSet(Vector3())
				else:
					VSet(Velocity-(FricForce/(Mass*60)))
				
		NormalForce = Vector3()
		FricForce = Vector3()
		
#From https://www.youtube.com/watch?v=U5qGj8qt7VU
func _on_Sphere_input_event(camera, event, position, normal, shape_idx):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT:
			Controler.SelectedBody = self
		if event.button_index == BUTTON_RIGHT:
			if Controler.TimeStopped == false:
				Controler.TimeStopped = true
			Controler.SelectedBody = self
