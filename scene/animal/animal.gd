extends RigidBody2D

#define and name the state of the animial
enum ANIMAL_STATE { READY, DRAG, RELEASE }

#limits the drag of both x and y and prevent it from going backwards
const  DRAG_LIM_MAX: Vector2 = Vector2(0,60)
const DRAG_LIM_MIN: Vector2 = Vector2(-60,0)

var _start: Vector2 = Vector2.ZERO
var _drag_start: Vector2 = Vector2.ZERO
var _dragged_vector: Vector2 = Vector2.ZERO

@onready var label: Label = $Label #debut purpose only

var _state: ANIMAL_STATE = ANIMAL_STATE.READY


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.
	_start = position

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	update(delta)
	label.text = "%s\n" % ANIMAL_STATE.keys()[_state]						#Debug. view state of animal
	label.text += "%.1f,%.1f" % [_dragged_vector.x, _dragged_vector.y]		#Debug. view drag cordinate of mouse

func set_new_state(new_state: ANIMAL_STATE) ->void:
	_state = new_state
	if _state == ANIMAL_STATE.RELEASE:
		freeze = false
	elif _state == ANIMAL_STATE.DRAG:
		_drag_start = get_global_mouse_position()


func detect_release() -> bool:
	if _state == ANIMAL_STATE.DRAG:
		if Input.is_action_just_released("drag") == true:
			set_new_state(ANIMAL_STATE.RELEASE)
			return true
	return false
	

func get_dragged_vector(gmp: Vector2) -> Vector2:
	return gmp - _drag_start

#Limits the amount that it could be dragged to be in peramiter.
func drag_in_limits() -> void:
	_dragged_vector.x = clampf(
		_dragged_vector.x,
		DRAG_LIM_MIN.x,
		DRAG_LIM_MAX.x
	)
	_dragged_vector.y = clampf(
		_dragged_vector.y,
		DRAG_LIM_MIN.y,
		DRAG_LIM_MAX.y
	)
	position = _start + _dragged_vector

#updates position according to mouse position
func update_drag() -> void:
	if detect_release() == true:
		return
		
	var gmp = get_global_mouse_position()
	_dragged_vector = get_dragged_vector(gmp)
	drag_in_limits()

#Updates the state of the animal
func update(delta:float) -> void:
	match _state:
		ANIMAL_STATE.DRAG:
			update_drag()



#Removes the animal 
func die() -> void:
	SignalManager.on_animal_died.emit() #Emits to Level
	queue_free()

#When the animal is off the screen
func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	die() 

#Detect mouse events
func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if _state == ANIMAL_STATE.READY and event.is_action_pressed("drag"):
		set_new_state(ANIMAL_STATE.DRAG)
