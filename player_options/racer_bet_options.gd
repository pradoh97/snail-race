extends VBoxContainer
class_name RacerBetOptions

@export var racer_name: = "Snail"
var bet_amount: = 0


signal bet_increased()
signal bet_decreased()

func _ready():
	disable_decrease()
	%RacerName.text = racer_name

func disable_decrease():
	$DecreaseBet.disabled = true

func enable_decrease():
	$DecreaseBet.disabled = false

func disable_increase():
	$IncreaseBet.disabled = true

func enable_increase():
	$IncreaseBet.disabled = false

func disable_all():
	disable_decrease()
	disable_increase()

func enable_all():
	enable_decrease()
	enable_increase()

func _on_increase_bet_pressed():
	bet_amount += 1
	$Money/HBoxContainer/CurrentMoney.text = str(bet_amount)
	bet_increased.emit()

	if bet_amount > 0:
		enable_decrease()


func _on_decrease_bet_pressed():
	if bet_amount > 0:
		bet_amount -= 1
		$Money/HBoxContainer/CurrentMoney.text = str(bet_amount)
		bet_decreased.emit()

	if bet_amount == 0:
		disable_decrease()
