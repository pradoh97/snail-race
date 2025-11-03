extends Node2D

var winner: String = ""

func _ready():
	$UI.restart_pressed.connect(_on_restart_pressed)
	var racer_number = 1
	for racer: Racer in $Racers.get_children():
		racer.racer_number = racer_number
		var racer_track = %Tracks.get_child(racer_number - 1)
		racer.vertical_boundaries.bottom = racer_track.global_position.y + racer_track.width/2
		racer.vertical_boundaries.top = racer_track.global_position.y - racer_track.width/2
		racer_number += 1
	place_traps()

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

func place_traps():
	var random_position = 0
	for trap: Trap in %Traps.get_children():
		random_position = randi_range(%TrapsSafeMargins.get_child(0).global_position.x, %TrapsSafeMargins.get_child(1).global_position.x)
		trap.global_position.x = random_position
