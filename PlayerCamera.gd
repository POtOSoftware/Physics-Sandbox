# https://godotengine.org/qa/24969/how-to-drag-camera-with-mouse

extends Camera2D

var mouse_start_pos
var screen_start_position

var dragging = false
var zoom_step = 1.1

var speed = 2.5

func _input(event):
	## CAMERA ZOOMING ##
	if event.is_action_released("scroll_up"):
		zoom_at_point(1/zoom_step, event.position)
	elif event.is_action_released("scroll_down"):
		zoom_at_point(zoom_step, event.position)
	## CAMERA ZOOMING ##
	
	## CAMERA DRAGGING ##
	if event.is_action("middle_click"):
		if event.is_pressed():
			mouse_start_pos = event.position
			screen_start_position = position
		dragging = event.is_pressed()
	elif event is InputEventMouseMotion and dragging:
		position = zoom * (mouse_start_pos - event.position) + screen_start_position
	## CAMERA DRAGGING ##

# https://godotengine.org/qa/25983/camera2d-zoom-position-towards-the-mouse
func zoom_at_point(zoom_change, point):
	var camera_pos = global_position        #c0
	var viewport_size = get_viewport().size #v0
	var next_camera_position                #c1
	var current_zoom = zoom                 #z0
	var next_zoom = zoom * zoom_change       #z1
	
	next_camera_position = camera_pos + (-0.5*viewport_size + point)*(current_zoom - next_zoom)
	zoom = next_zoom
	global_position = next_camera_position

## CAMERA MOVING ##
func get_input():
	# Not gonna lie I didn't expect this to work
	if Input.is_action_pressed("ui_right"):
		position.x += speed
	if Input.is_action_pressed("ui_left"):
		position.x -= speed
	if Input.is_action_pressed("ui_down"):
		position.y += speed
	if Input.is_action_pressed("ui_up"):
		position.y -= speed
	
	# This part's a little janky, but who cares lmao
	if Input.is_action_pressed("speed_up"):
		speed = 5
	if Input.is_action_just_released("speed_up"):
		speed = 2.5
	if Input.is_action_pressed("slow_down"):
		speed = 1
	if Input.is_action_just_released("slow_down"):
		speed = 2.5

func _physics_process(delta):
	get_input()
## CAMERA MOVING ##
