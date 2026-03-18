extends Control


# ======================
# VARIABLES
# ======================

var score = 0
var time_left = 10
var playing = false
var high_score = 0
var popups = []

# ======================
# NODE REFERENCES
# ======================

@onready var score_label = $VBoxContainer/Panel/HBoxContainer/ScoreLabel
@onready var time_label = $VBoxContainer/Panel/HBoxContainer/TimeLabel
@onready var tap_button = $VBoxContainer/TapButton

@onready var explosion = $Explosion
@onready var tap_sound = $TapSound

@onready var countdown_popup = $CountdownPopup
@onready var countdown_label = $CountdownPopup/CountdownLabel

@onready var game_over_popup = $GameOverPopup
@onready var game_over_high_score_label = $GameOverPopup/HighScoreLabel

@onready var high_score_popup = $HighScorePopup
@onready var high_score_label = $HighScorePopup/HighScoreLabel


# ======================
# READY
# ======================

func _ready():

	tap_button.disabled = true
	explosion.emitting = false
	popups = [
		$CountdownPopup,
		$GameOverPopup,
		$HighScorePopup
	]
	hide_all_popups()
	load_high_score()
	start_countdown()


# ======================
# LOAD HIGH SCORE
# ======================

func load_high_score():

	if FileAccess.file_exists("user://save.dat"):

		var file = FileAccess.open("user://save.dat", FileAccess.READ)

		high_score = file.get_var()


# ======================
# COUNTDOWN
# ======================

func start_countdown():

	show_popup($CountdownPopup)
	for n in ["3","2","1","GO"]:
		countdown_label.text = n
		countdown_bounce()
		await get_tree().create_timer(1).timeout
	hide_popup($CountdownPopup)
	start_game()

func countdown_bounce():

	countdown_label.scale = Vector2(0.4,0.4)

	var tween = create_tween()

	tween.tween_property(countdown_label,"scale",Vector2(1.3,1.3),0.2)
	tween.tween_property(countdown_label,"scale",Vector2(0.9,0.9),0.1)
	tween.tween_property(countdown_label,"scale",Vector2(1,1),0.1)
# ======================
# START GAME
# ======================

func start_game():

	score = 0
	time_left = 10
	playing = true

	score_label.text = "Score: 0"
	time_label.text = "Time: 10"

	tap_button.disabled = false

	start_timer()


# ======================
# TIMER
# ======================

func start_timer():

	while playing:

		await get_tree().create_timer(1).timeout

		time_left -= 1

		if time_left <= 0:

			time_left = 0
			time_label.text = "Time: 0"

			end_game()

			break

		time_label.text = "Time: " + str(time_left)


# ======================
# TAP BUTTON
# ======================

func _on_TapButton_pressed():

	if not playing:
		return

	Input.vibrate_handheld(30)

	score += 1
	score_label.text = "Score: " + str(score)

	tap_sound.play()

	tap_flash()

	explode_effect()


# ======================
# END GAME
# ======================

func end_game():

	playing = false
	tap_button.disabled = true
	if score > high_score:
		high_score = score
		save_high_score()
		show_popup($HighScorePopup)
	else:
		show_popup($GameOverPopup)


# ======================
# SAVE HIGH SCORE
# ======================

func save_high_score():

	if score > high_score:

		high_score = score

		var file = FileAccess.open("user://save.dat", FileAccess.WRITE)

		file.store_var(high_score)

# ======================
# PLAY AGAIN BUTTON
# ======================

func _on_PlayButton_pressed():

	game_over_popup.visible = false

	start_countdown()


# ======================
# HOME BUTTON
# ======================

func _on_HomeButton_pressed():

	get_tree().change_scene_to_file("res://scenes/tutorial_panel.tscn")


# ======================
# TAP FLASH EFFECT
# ======================

func tap_flash():

	tap_button.modulate = Color(1.5,1.5,1.5)

	tap_button.scale = Vector2(1.1,1.1)

	await get_tree().create_timer(0.07).timeout

	tap_button.modulate = Color(1,1,1)

	tap_button.scale = Vector2(1,1)


# ======================
# EXPLOSION EFFECT
# ======================

func explode_effect():

	var pos = tap_button.get_global_rect().get_center()

	explosion.global_position = pos

	explosion.restart()

	explosion.emitting = true
	
	
func hide_all_popups():
	$CountdownPopup.visible = false
	$GameOverPopup.visible = false
	$HighScorePopup.visible = false

func show_popup(popup):

	hide_all_popups()

	popup.visible = true

	popup.scale = Vector2(0.4,0.4)

	var tween = create_tween()

	tween.tween_property(popup,"scale",Vector2(1.2,1.2),0.2)
	tween.tween_property(popup,"scale",Vector2(1,1),0.1)
	
func hide_popup(popup):

	var tween = create_tween()

	tween.tween_property(popup,"modulate:a",0,0.3)

	await tween.finished

	popup.visible = false
	popup.modulate.a = 1
