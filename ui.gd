extends CanvasLayer
class_name UI

signal restart_pressed

var last_bet = {
	"texture": null,
	"money": 0,
	"racer": 0
}

func _ready():
	%CurrentMoney.text = str(Globals.money)
	$GameOver.visible = false

	for container in %BetSpace.get_children():
		var small_button: Button = container.get_node("SmallBetButton")

		small_button.pressed.connect(func():
			last_bet.texture = small_button.get_parent().get_node("SmallBet")
			last_bet.texture.visible = true
			last_bet.money = 1
			last_bet.racer = container.get_node("Racer").text[-1]
			small_button.visible = false
			start_race()
		)
		var large_button: Button = container.get_node("LargeBetButton")
		large_button.pressed.connect(func():
			last_bet.texture = large_button.get_parent().get_node("LargeBet")
			last_bet.money = 5
			last_bet.texture.visible = true
			last_bet.racer = container.get_node("Racer").text[-1]
			large_button.visible = false
			start_race()
		)

func start_race():
	$GameOver.visible = false
	get_parent().start_race()
	hide_bet_options()

func hide_bet_options():
	for container in %BetSpace.get_children():
		var small_button: Button = container.get_node("SmallBetButton")
		var large_button: Button = container.get_node("LargeBetButton")

		small_button.disabled = true
		large_button.disabled = true
		small_button.visible = false
		large_button.visible = false

func show_bet_options():
	for container in %BetSpace.get_children():
		var small_button: Button = container.get_node("SmallBetButton")
		var large_button: Button = container.get_node("LargeBetButton")

		small_button.disabled = false
		large_button.disabled = false
		small_button.visible = true
		large_button.visible = true
		last_bet.texture.visible = false

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
	show_bet_options()
	restart_pressed.emit()
