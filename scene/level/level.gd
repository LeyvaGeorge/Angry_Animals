extends Node2D

const ANIMAL = preload("res://scene/animal/animal.tscn")
const MAIN = preload("res://scene/main/main.tscn")

#Location of where the bird will start
@onready var animal_start: Marker2D = $AnimalStart
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	add_animal()
	SignalManager.on_animal_died.connect(add_animal) #Emit from animal died

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_key_pressed(KEY_ESCAPE): #changes the scene back to main menu when escape is pressed
		get_tree().change_scene_to_packed(MAIN) 

#creates an instance and moves it to position
func add_animal() -> void:
	var animal = ANIMAL.instantiate()
	animal.position = animal_start.position
	add_child(animal)
