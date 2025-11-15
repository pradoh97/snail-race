extends Node2D

var winner: String = ""
var snails_bet_pool = {}

func _ready():
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
		calculate_pool(body)
		$UI.race_over(winner, snails_bet_pool)

func _on_full_stop_body_entered(body):
	(body as Racer).race_over = true

func calculate_pool(winner_node: Racer):
		var winner_total_bets = snails_bet_pool.player_1[str(winner_node.racer_number)].bet_amount + snails_bet_pool.player_2[str(winner_node.racer_number)].bet_amount
		var total_bets = 0
		for racer: Racer in $Racers.get_children():
			total_bets += snails_bet_pool.player_1[str(racer.racer_number)].bet_amount
			total_bets += snails_bet_pool.player_2[str(racer.racer_number)].bet_amount

		if not snails_bet_pool.player_1[str(winner_node.racer_number)].bet_amount == 0:
			snails_bet_pool.player_1[str(winner_node.racer_number)].participation = float(snails_bet_pool.player_1[str(winner_node.racer_number)].bet_amount)/float(winner_total_bets)
		if not snails_bet_pool.player_2[str(winner_node.racer_number)].bet_amount == 0:
			snails_bet_pool.player_2[str(winner_node.racer_number)].participation = float(snails_bet_pool.player_2[str(winner_node.racer_number)].bet_amount)/float(winner_total_bets)
		snails_bet_pool.player_2.reward = roundi(total_bets * snails_bet_pool.player_2[str(winner_node.racer_number)].participation)
		snails_bet_pool.player_1.reward = roundi(total_bets * snails_bet_pool.player_1[str(winner_node.racer_number)].participation)
		snails_bet_pool.player_1.total_bet = snails_bet_pool.player_1["1"].bet_amount + snails_bet_pool.player_1["2"].bet_amount + snails_bet_pool.player_1["3"].bet_amount
		snails_bet_pool.player_2.total_bet = snails_bet_pool.player_2["1"].bet_amount + snails_bet_pool.player_2["2"].bet_amount + snails_bet_pool.player_2["3"].bet_amount
		Globals.money.player_1 += snails_bet_pool.player_1.reward
		Globals.money.player_2 += snails_bet_pool.player_2.reward

func start_race(bets_pool):
	snails_bet_pool = bets_pool

	for racer: Racer in $Racers.get_children():
		racer.set_physics_process(true)
		$UI/StartRace.visible = false
		$UI/PlayerOptions.start_race()
		$UI/PlayerOptions2.start_race()
	$AudioStreamPlayer.play()


func place_traps():
	var random_position = 0
	for trap: Trap in %Traps.get_children():
		random_position = randi_range(%TrapsSafeMargins.get_child(0).global_position.x, %TrapsSafeMargins.get_child(1).global_position.x)
		trap.global_position.x = random_position


func _on_player_options_place_trap(racer):
	var trap = %Traps.get_children()[0].duplicate()
	var random_position = randi_range(%TrapsSafeMargins.get_child(0).global_position.x, %TrapsSafeMargins.get_child(1).global_position.x)
	var vertical_position = 0
	%Traps.add_child(trap)
	vertical_position = %Tracks.get_child(racer - 1).global_position.y
	trap.global_position = Vector2(random_position, vertical_position)


func _on_ui_next_race_pressed():
	winner = ""
	get_tree().reload_current_scene()
