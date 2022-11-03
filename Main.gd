extends Node2D

onready var cursor = $UILayer/Cursor
var mouse_pos = Vector2()
var mouse_speed = 8.0

var slow_motion = false

func _ready():
	randomize()
	
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)

func _process(delta):
	var mouse_rel = Vector2.ZERO
	if Input.is_action_pressed("left_stick_up"):
		mouse_rel += Vector2.UP * mouse_speed
	elif Input.is_action_pressed("left_stick_down"):
		mouse_rel += Vector2.DOWN * mouse_speed
	elif Input.is_action_pressed("left_stick_left"):
		mouse_rel += Vector2.LEFT * mouse_speed
	elif Input.is_action_pressed("left_stick_right"):
		mouse_rel += Vector2.RIGHT * mouse_speed
	if mouse_rel != Vector2.ZERO:
		Input.warp_mouse_position(mouse_pos + mouse_rel)
	cursor.position = get_global_mouse_position()

func _input(event):
	if event is InputEventMouseMotion:
		mouse_pos = event.position
	
	if event.is_action_pressed("spawn_box"):
		var box = load("res://Objects/Box.tscn")
		var new_box = box.instance()
		new_box.position = get_global_mouse_position()
		new_box.add_to_group("object")
		
		new_box.modulate = random_color()
		add_child(new_box)
	
	if event.is_action_pressed("right_click"):
		throw_ball(Vector2(500, 0))
	
	if event.is_action_pressed("left_click"):
		throw_ball(Vector2(-500, 0))
	
	if event.is_action_pressed("slow_motion"):
		slow_motion = !slow_motion
		if slow_motion:
			Engine.set_time_scale(0.25)
		else:
			Engine.set_time_scale(1)
	
	if event.is_action_pressed("reset_objects"):
		for object in get_tree().get_nodes_in_group("object"):
			object.queue_free()
	
	if event.is_action_pressed("undo_last_object"):
		var objects = get_tree().get_nodes_in_group("object")
		if not objects.empty():
			var object_to_delete = objects[-1]
			object_to_delete.queue_free()

func random_color():
	return Color.from_hsv(rand_range(0.0, 1.0), rand_range(0.0, 1.0), 1.0)

func throw_ball(direction):
	var ball = load("res://Objects/Ball.tscn")
	var new_ball = ball.instance()
	new_ball.position = get_global_mouse_position()
	new_ball.apply_impulse(Vector2(0,0), direction)
	new_ball.add_to_group("object")
	add_child(new_ball)

