extends Node2D

var winner: String = ""

func _on_finish_line_body_entered(body):
	if not winner:
		winner = body.name


func _on_full_stop_body_entered(body):
	(body as Racer).race_over = true

func start_race():
	for racer: Racer in $Racers.get_children():
		racer.set_physics_process(true)
