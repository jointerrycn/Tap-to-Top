extends Control

@onready var finger = $Finger
@onready var button = $Circle

var finger_start
var button_start_scale

func _ready():
	finger_start = finger.position
	button_start_scale = button.scale
	animate_finger()

func animate_finger():

	var tween = create_tween()
	tween.set_loops() # loop vô hạn

	# finger chạm xuống
	tween.tween_property(finger,"position",finger_start + Vector2(0,15),0.2)
	tween.parallel().tween_property(finger,"scale",Vector2(0.9,0.9),0.2)

	# button lún
	tween.parallel().tween_property(button,"scale",Vector2(0.92,0.92),0.2)

	# finger trở lại
	tween.tween_property(finger,"position",finger_start,0.2)
	tween.parallel().tween_property(finger,"scale",Vector2(1,1),0.2)

	# button trở lại
	tween.parallel().tween_property(button,"scale",button_start_scale,0.2)


func go_to_main():
	get_tree().change_scene_to_file("res://scenes/main.tscn")


func _input(event):
	if event is InputEventScreenTouch and event.pressed:
		go_to_main()
	if event is InputEventMouseButton and event.pressed:
		go_to_main()
