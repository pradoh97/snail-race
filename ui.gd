extends CanvasLayer

func _ready():
	for container in %BetSpace.get_children():
		var button: Button = container.get_node("Button")
		button.pressed.connect(func():
			start_race()
			var bet_scene: Control = preload("res://bets/medium_bet.tscn").instantiate()
			bet_scene.position = button.position
			bet_scene.position += button.size/2
			bet_scene.offset_left = button.offset_left
			bet_scene.offset_top = button.offset_top
			bet_scene.offset_right = button.offset_right
			bet_scene.offset_bottom = button.offset_bottom

			%Table.add_child(bet_scene)
		)

func start_race():
	get_parent().start_race()

	hide_bet_options()

func hide_bet_options():
	for container in %BetSpace.get_children():
		var button: Button = container.get_node("Button")
		button.disabled = true
		button.visible = false
