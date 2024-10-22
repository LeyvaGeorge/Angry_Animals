extends Node2D

const ANIMAL = preload("res://scene/animal/animal.tscn")


#Location of where the bird will start
@onready var animal_start: Marker2D = $AnimalStart
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	add_animal()
	SignalManager.on_animal_died.connect(add_animal) #Emit from animal died


#creates an instance and moves it to position
func add_animal() -> void:
	var animal = ANIMAL.instantiate()
	animal.position = animal_start.position
	add_child(animal)
