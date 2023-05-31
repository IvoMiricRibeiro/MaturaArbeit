extends RichTextLabel

onready var BAVC = get_parent()
onready var BAVCSDictionary = get_parent().BodiesDictionary


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _process(delta):
	#for i in BAVCSDictionary.values():
		#add_text(BAVCSDictionary)
		#print(BAVCSDictionary)
	#clear()
	pass

func newtext():
	add_text("Bababooey")
