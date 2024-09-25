extends RigidBody2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	pass

#Removes the animal 
func die() -> void:
	SignalManager.on_animal_died.emit() #Emits to Level
	queue_free()

#When the animal is off the screen
func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	die() 
