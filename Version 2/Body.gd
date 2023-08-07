extends KinematicBody

var Velocity = Vector3() setget VSet , VGet 
var Acceleration = Vector3() setget ASet, AGet
var Mass = 1 setget MSet, MGet

var Elastic = false

var OuterForces = [] #List with the force of gravity and forces of other objects
var InnerForce = Vector3() #Force calculated with the "real" acceleration
var ResForce = Vector3() #Sum of all forces

var CollidedOnce = false setget CollideSet , CollideGet

onready var Controler = get_parent()
onready var CMesh = $CSGMesh
var canaccelerate = true

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

#Setters and Getter functions
func VSet(param):
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

func _process(delta):
	if Controler.SelectedBody == self:
		CMesh.material.next_pass.set_shader_param("border_width", 0.1) #Nicely taken from the 3.5 docs
	else:
		CMesh.material.next_pass.set_shader_param("border_width", 0)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	#Time stopping code
	if Controler.TimeStopped == false:
		#Collisions
		for index in get_slide_count():
			var body = get_slide_collision(index).collider
			#Code for other Kinematic Bodies
			if body is KinematicBody and CollideGet() == false:
				CollideSet(true)
				body.CollideSet(true)
				#Useful variables
				var V1 = self.VGet()
				var V2 = body.VGet()
				var M1 = self.MGet()
				var M2 = body.MGet()
				#Code for elastic collisions
				if Elastic == true and body.Elastic == true:
					var PD1 = self.translation-body.translation
					var PD2 = body.translation-self.translation
					var V1n = V1-(((2*M2)/(M1+M2))*(((Vector3(V1-V2).dot(PD1))/(PD1.length()*PD1.length()))*PD1))
					var V2n = V2-(((2*M1)/(M1+M2))*(((Vector3(V2-V1).dot(PD2))/(PD2.length()*PD2.length()))*PD2))
					VSet(V1n)
					body.VSet(V2n)
				#Inelastic collisions here
				if Elastic == false and body.Elastic == false:
					var Vn = ((M1*V1)+(M2*V2))/(M1+M2)
					VSet(Vn)
					body.VSet(Vn)
					#SET INNER FORCE FOR OTHER BODY?
			if body is StaticBody:
				var V = self.VGet()
				if Elastic == false:
					var d = self.translation-body.translation
					canaccelerate = false
					match body.collision_layer:
						1:
							if (d.x < 0 and V.x > 0) or (d.x > 0 and V.x < 0):
								VSet(Vector3(0, V.y, V.z))
						2:
							if (d.y < 0 and V.y > 0) or (d.y > 0 and V.y < 0):
								VSet(Vector3(V.x, 0, V.z))
						4:
							if (d.z < 0 and V.z > 0) or (d.z > 0 and V.z < 0):
								VSet(Vector3(V.x, V.y, 0))
				if Elastic == true:
					match body.collision_layer:
						1:
							VSet(Vector3(-V.x, V.y, V.z))
						2:
							VSet(Vector3(V.x, -V.y, V.z))
						4:
							VSet(Vector3(V.x, V.y, -V.z))
				break #This needs to be here otherwise the damn for loop might reset for unknown reasons
				
		print(canaccelerate)
		#Acceleration, gravity, and forces
		if canaccelerate == true:
			VSet(VGet()+(AGet()/60)) #Problem: v not 0 when against the floor or walls
		if Controler.GravityExists == true:
			if canaccelerate == true:
				VSet(VGet()+(Vector3(0, -9.81, 0)/60))
			OuterForces.append(Vector3(0, -9.81, 0)*Mass)
			
		InnerForce = AGet()*Mass
		ResForce = InnerForce
		for j in OuterForces.size():
			ResForce += OuterForces[j]
		
		move_and_slide(self.VGet())
		OuterForces = []
		CollideSet(false)
		
#From https://www.youtube.com/watch?v=U5qGj8qt7VU
func _on_Sphere_input_event(camera, event, position, normal, shape_idx):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and event.pressed == true:
			Controler.SelectedBody = self
		if event.button_index == BUTTON_RIGHT and event.pressed == true:
			if Controler.TimeStopped == false:
				Controler.TimeStopped = true
			Controler.SelectedBody = self
