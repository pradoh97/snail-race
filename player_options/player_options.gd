class_name PlayerOptions extends PanelContainer

signal place_trap(racer: int)
@export var player_name: String = "Player 1"

func _ready():
	$VBoxContainer/PlayerName.text = player_name
	if player_name == "Player 1":
		%Balance.current_balance = str(Globals.money.player_1)
	if player_name == "Player 2":
		%Balance.current_balance = str(Globals.money.player_2)
	%Balance.update_balance()

func get_balance():
	return %Balance.current_balance

func get_bets():
	return {
		"1": {
			"bet_amount": $VBoxContainer/HboxContainer/RacerBetOptions.bet_amount,
			"participation": 0.0,
			"reward": 0,
		},
		"2": {
			"bet_amount": $VBoxContainer/HboxContainer/RacerBetOptions2.bet_amount,
			"participation": 0.0,
			"reward": 0,
		},
		"3": {
			"bet_amount": $VBoxContainer/HboxContainer/RacerBetOptions3.bet_amount,
			"participation": 0.0,
			"reward": 0,
		},
	}

func _on_balance_balance_drained():
	disable_increases()

func _on_balance_balance_restored():
	enable_decreases()

func start_race():
	if player_name == "Player 1":
		Globals.money.player_1 = get_balance()
	if player_name == "Player 2":
		Globals.money.player_2 = get_balance()
	disable_options()

func disable_options():
	disable_increases()
	disable_decreases()

func disable_increases():
	$VBoxContainer/HboxContainer/RacerBetOptions.disable_increase()
	$VBoxContainer/HboxContainer/RacerBetOptions2.disable_increase()
	$VBoxContainer/HboxContainer/RacerBetOptions3.disable_increase()

func enable_increases():
	$VBoxContainer/HboxContainer/RacerBetOptions.enable_increase()
	$VBoxContainer/HboxContainer/RacerBetOptions2.enable_increase()
	$VBoxContainer/HboxContainer/RacerBetOptions3.enable_increase()

func disable_decreases():
	$VBoxContainer/HboxContainer/RacerBetOptions.disable_decrease()
	$VBoxContainer/HboxContainer/RacerBetOptions2.disable_decrease()
	$VBoxContainer/HboxContainer/RacerBetOptions3.disable_decrease()

func enable_decreases():
	$VBoxContainer/HboxContainer/RacerBetOptions.enable_decrease()
	$VBoxContainer/HboxContainer/RacerBetOptions2.enable_decrease()
	$VBoxContainer/HboxContainer/RacerBetOptions3.enable_decrease()


func _on_racer_bet_options_place_trap(racer: int):
	if %Balance.current_balance >= 5:
		place_trap.emit(racer)
