extends Node2D

var winner: String = ""

func _on_finish_line_body_entered(body):
	if not winner:
		winner = body.name
		print(winner, " won.")


func _on_full_stop_body_entered(body):
	(body as Racer).race_over = true
