extends CanvasLayer
class_name UI

signal restart_pressed

var last_bet = [
	{
		"texture": null,
		"money": 0
	},
	{
		"texture": null,
		"money": [0,0,0]
	},
]

var player_1_balance_label: Label
var player_2_balance_label: Label

func _ready():
	$GameOver.visible = false

func start_race():
	$GameOver.visible = false
	get_parent().start_race()

func race_over(winner: String):
	$GameOver.visible = true
	%Winner.text = winner
	if winner == last_bet.racer:
		%MoneyResult.text = "You won +$"
		Globals.money += last_bet.money
	else:
		%MoneyResult.text = "You lost -$"
		Globals.money -= last_bet.money
	%MoneyResult.text +=  str(last_bet.money)
	%CurrentMoney.text = str(Globals.money)


func _on_quit_pressed():
	get_tree().quit()


func _on_restart_pressed():
	$GameOver.visible = false
	restart_pressed.emit()
