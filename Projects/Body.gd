extends KinematicBody

var Mass = 1
var Direction = Vector3()
var Velocity = Vector3()
var Acceleration = Vector3()
#var Force = Acceleration*60*Mass*Direction

var i = 0
var OuterForces = [] #Exist even when there are no collisions, should theoretically be constant
var InnerForces = [] #Basically outer forces from other objects, exist during collisions only and for calculation purposes only
var ResForce = Vector3() #Sum of all forces exerced onto the Kinematic Body
var CollidingWith = []

var KineticEnergy = Vector3()

#Variables for testing and calculations
var StartPosition = Vector3()
var EndPosition = Vector3()

var IsElastic = true
var HasElasCollided = false
var TempVelocity = Vector3()


onready var BAVC = get_parent()
onready var BAVCSDictionary = get_parent().BodiesDictionary


func _ready():
	#if get_node("../Gravity"):
	#	print("Snap back to reality")
	#OuterForces.append(Mass*Vector3(0,-9.81,0))
	
	#"Registers" itself in the BAVCS
	BAVCSDictionary[self] = [Mass, Velocity, Acceleration, CollidingWith, ResForce, OuterForces]
	#print(BAVCSDictionary[self])
	
func _physics_process(delta):
	
	#Velocity += Acceleration
	
	for index in get_slide_count():
		var collision = get_slide_collision(index)
		#Collision against another Kinematic Body
		if collision.collider is KinematicBody:
			CollidingWith = BAVCSDictionary[self][3]
			#All stuff back
			if !CollidingWith.has(collision.collider):
				BAVC.CollisionChecker(self, collision.collider)
				var ColIsElastic = collision.collider.IsElastic
				
				#Code for full elastic collisions
				if IsElastic == true and ColIsElastic == true:
					BAVC.ElasticCollision(self,collision.collider)
					Velocity = BAVCSDictionary[self][1]
				#Code for full-non elastic collisions
				if IsElastic == false and ColIsElastic == false:
					BAVC.NonElasticCollision(self, collision.collider)
					Velocity = BAVCSDictionary[self][1]
			
				BAVC.CollisionEnder(self, collision.collider)
			#BAVC.CollisionForceCalc(self, collision.collider)
			
		if collision.collider is StaticBody:
			#Elastic collisions, again.
			if IsElastic == true:
				if collision.collider.collision_layer == 1:
					Velocity.x = -Velocity.x
				if collision.collider.collision_layer == 2:
					Velocity.y = -Velocity.y
				if collision.collider.collision_layer == 3:
					Velocity.z = -Velocity.z
		
			if IsElastic == false:
				if collision.collider.collision_layer == 1:
					Velocity.x = 0
				if collision.collider.collision_layer == 2:
					Velocity.y = 0
				if collision.collider.collision_layer == 3:
					Velocity.z = 0
		
		#Forces
		#var dist = self.get_translation()-collision.collider.get_translation()
		#var newvec = collision.collider.ResForce
	
	#print("OuterForces: ", OuterForces)
	
	OuterForces = BAVCSDictionary[self][5]
	
	while i < OuterForces.size():
		ResForce += OuterForces[i]
		i += 1
	i = 0
	#print("Res: ", ResForce)
	
	while i < InnerForces.size():
		ResForce += InnerForces[i]
	i = 0
	
	#Take the force, calculate stuff, then move
	#print("Res: ", ResForce)
	#Acceleration = ((ResForce/Mass)/60)
	#Acceleration = BAVCSDictionary[self][2]
	
	print("V: ", Velocity)
	print("A: ", Acceleration)
	print("A2: ", BAVCSDictionary[self][2])
	#Velocity += Acceleration
	
	
	Velocity = BAVCSDictionary[self][1]
	BAVC.Accelarate(self)
	Velocity = BAVCSDictionary[self][1]
	#nDirection = ResForce.normalized().abs()
	#KineticEnergy = 0.5*Mass*Velocity*Velocity
	#print("Kinetic: ", KineticEnergy, "J")
	#print("v: ", Velocity)
	#print("d: ", Direction)
	#print("v*d: ", Velocity*Direction)
	move_and_slide(Velocity)
	ResForce = Vector3()
	
func _on_Timer_timeout():
	print("It just works")
	EndPosition = self.get_translation()
	print("End Position: ", EndPosition)
	print("Distance travelled:", EndPosition-StartPosition)

#func _on_Button_pressed():
#	print("Brah")




#func _on_Cube_KeepVelocity(KeptVelocity):
#	print("Signal sent")
#	Velocity = KeptVelocity
