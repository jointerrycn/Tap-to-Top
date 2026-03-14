extends Control

var score = 0
var time_left = 10
var playing = false

@onready var score_label = $ScoreLabel
@onready var time_label = $TimeLabel
@onready var tap_button = $TapButton

func _ready():
	tap_button.disabled = true

func _on_StartButton_pressed():

	score = 0
	time_left = 10
	playing = true

	score_label.text = "Score: 0"
	time_label.text = "Time: 10"

	tap_button.disabled = false

	start_timer()

func start_timer():

	while time_left > 0:

		await get_tree().create_timer(1.0).timeout

		time_left -= 1
		time_label.text = "Time: " + str(time_left)

	end_game()

func _on_TapButton_pressed():

	if not playing:
		return

	score += 1
	score_label.text = "Score: " + str(score)

func end_game():

	playing = false
	tap_button.disabled = true
