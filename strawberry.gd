extends Area2D
class_name Trap

func _on_body_entered(racer: Racer):
	racer.trap_in_sight = self


func _on_body_exited(racer: Racer):
	if not (racer.trapped and racer.trap_in_sight == self):
		racer.trap_in_sight = null

func get_consume_area() -> Vector2:
	return $EatArea.global_position
