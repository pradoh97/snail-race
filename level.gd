extends Node2D

var winner: String = ""

func _ready():
	$UI.restart_pressed.connect(_on_restart_pressed)
	var racer_number = 1
	for racer: Racer in $Racers.get_children():
		racer.racer_number = racer_number
		racer_number += 1

func _on_finish_line_body_entered(body):
	if not winner:
		winner = str(body.racer_number)
		$UI.race_over(winner)

func _on_full_stop_body_entered(body):
	(body as Racer).race_over = true

func start_race():
	for racer: Racer in $Racers.get_children():
		racer.set_physics_process(true)

func _on_restart_pressed():
	winner = ""
	get_tree().reload_current_scene()
