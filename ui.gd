extends CanvasLayer
class_name UI

signal next_race_pressed

var player_1_balance_label: Label
var player_2_balance_label: Label

func _ready():
	$GameOver.visible = false

func start_race():
	var bets_pool = {}
	bets_pool.player_1 = $PlayerOptions.get_bets()
	bets_pool.player_2 = $PlayerOptions2.get_bets()
	$GameOver.visible = false
	get_parent().start_race(bets_pool)
	disable_player_options()

func race_over(winner: String, snails_bet_pool):
	$GameOver.visible = true
	%Winner.text = "Snail " + str(winner)
	var player_1_gains = snails_bet_pool.player_1.reward - snails_bet_pool.player_1.total_bet
	var player_2_gains = snails_bet_pool.player_2.reward - snails_bet_pool.player_2.total_bet
	if player_1_gains > 0:
		$GameOver/VBoxContainer/MoneyResultPlayer1.text = "Player 1 won $" + str(player_1_gains)
	elif player_1_gains == 0:
		$GameOver/VBoxContainer/MoneyResultPlayer1.text = "Break even for player 1"
	else:
		$GameOver/VBoxContainer/MoneyResultPlayer1.text = "Player 1 lost $" + str(player_1_gains)
	if player_2_gains > 0:
		$GameOver/VBoxContainer/MoneyResultPlayer2.text = "Player 2 won: $" + str(player_2_gains)
	elif player_2_gains == 0:
		$GameOver/VBoxContainer/MoneyResultPlayer2.text = "Break even for player 2"
	else:
		$GameOver/VBoxContainer/MoneyResultPlayer2.text = "Player 2 lost $" + str(player_2_gains)
	if Globals.money.player_1 == 0:
		$GameOver/VBoxContainer/MoneyResultPlayer1.text += " also... you lost all your money."
	if Globals.money.player_2 == 0:
		$GameOver/VBoxContainer/MoneyResultPlayer2.text += " also... you lost all your money."
	for player in Globals.money:
		if Globals.money[player] == 0:
			%Restart.visible = true
			%NextRace.visible = false

func disable_player_options():
	$PlayerOptions.disable_options()
	$PlayerOptions2.disable_options()

func enable_player_options():
	$PlayerOptions.enable_options()
	$PlayerOptions2.enable_options()

func _on_quit_pressed():
	get_tree().quit()


func _on_next_race_pressed():
	$GameOver.visible = false
	next_race_pressed.emit()
	enable_player_options()


func _on_start_race_pressed():
	start_race()


func _on_restart_pressed():
	for player in Globals.money:
		Globals.money[player] = 20
	next_race_pressed.emit()
