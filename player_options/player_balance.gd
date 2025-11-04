class_name PlayerBalance extends HBoxContainer

signal balance_drained
signal balance_restored

var current_balance: int = 0

func update_balance():
	%CurrentBalance.text = str(current_balance)
	if current_balance == 0:
		balance_drained.emit()
	else:
		balance_restored.emit()

func _on_racer_bet_options_bet_decreased():
	current_balance += 1
	update_balance()

func _on_racer_bet_options_bet_increased():
	if current_balance > 0:
		current_balance -= 1
		update_balance()
