extends Node


# Game related data here
export var sd_cash_rate = 100
export var fuel_unit_cost = 0.05
export var min_debt_payment_rate = 0.01

export var upgrade_thrust_price = 500

# Called when the node enters the scene tree for the first time.
func _ready():
	start_HUD()


func start_HUD():
	update_HUD_player_stats()

func update_HUD_player_stats():
	$HUD.update_spaceDustCargo($Player.SDC)
	$HUD.update_fuel($Player.fuel)
	$HUD.update_money($Player.money)
	$HUD.update_debt($Player.debt)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _on_Player_player_hit_spaceDust():
	$SDHarvestSound.play()
	$HUD.update_spaceDustCargo($Player.SDC)

func _on_Player_player_update_fuel():
	$HUD.update_fuel($Player.fuel)

func _on_Player_player_fuel_empty():
	$HUD.update_fuel(0)
	#tow back the player and go to pre launch run screen

func _on_Enemy_enemy_hit_player():
	$Player.handle_enemy_hit($Enemy.damage) # Replace with function body.

func _on_Player_player_update_vel():
	$HUD.update_velocity($Player.linear_velocity)

func _on_Player_player_SDC_full():
	$HUD/SpaceDustCargoLabel/SDCFullLabel.visible = true
	$HUD/ExitAreaLabel.visible = true

# calculate the players run
func _on_Player_player_hit_exit_area():
	$HUD/SummaryLabel.visible = true
	var sd_total = $Player.SDC * sd_cash_rate
	var fuel_used = $Player.fuel_max - $Player.fuel
	var fuel_total = fuel_used * fuel_unit_cost
	var debt_payment = $Player.debt * min_debt_payment_rate
	var debt_remaining = $Player.debt - debt_payment
	var fees = fuel_total + debt_payment
	var earned_total = sd_total - fees
	$HUD/SpaceDustCargoLabel/SDCFullLabel.visible = false
	$HUD/ExitAreaLabel.visible = false
	$HUD.update_sum_sd($Player.SDC, sd_cash_rate, sd_total)
	$HUD.update_sum_fuel(fuel_used, fuel_unit_cost, fuel_total)
	$HUD.update_sum_debt($Player.debt, debt_payment, debt_remaining)
	$HUD.update_sum_earned(sd_total, fees, earned_total)
	update_player_money(earned_total, debt_remaining) # add money to player from their run

func update_player_money(earned, debt_remaining):
	if earned > 0:
		$Player.debt = debt_remaining
		$Player.money += earned
	elif earned < 0: #Lost money
		if earned - $Player.money >= 0:
			 $Player.money -= earned	
		else:
			var remainder = earned + $Player.money
			$Player.money = 0
			$Player.debt += abs(remainder) # losing money that you cant cover adds to debt
	$HUD.update_money($Player.money)
	update_HUD_player_stats()

func _on_HUD_sum_confirm_click():
	$HUD/SummaryLabel.visible = false
	$HUD/UpgradeLabel.visible = true
	$HUD.update_upgrade_money($Player.money)

func _on_HUD_thrust_purchased():
	if $Player.money - upgrade_thrust_price >= 0:
		$Player.engine_thrust += 100
		$Player.money -= upgrade_thrust_price
		$HUD.update_upgrade_money($Player.money)

func _on_HUD_upgrade_confirm_click():
	$HUD/UpgradeLabel.visible = false
	game_reset()
	

func game_reset():
	$Player.transform.origin.x = -246
	$Player.transform.origin.y = 1245
	$Player.rotation_degrees = 0
	$Player.pause_player = false;
	$Player.SDC = 0
	$Player.fuel = $Player.fuel_max
	get_tree().call_group("SDClouds", "level_reset")
	update_HUD_player_stats()
	
func setup_player_game_start():
	$Player.SDC = 0
	$Player.SDC_max = $Player.start_sdc_max
	$Player.fuel = $Player.start_fuel_max
	$Player.fuel_max = $Player.start_fuel_max
	$Player.money = 0
	$Player.debt = $Player.start_debt
	$Player.fuel_consume_rate = $Player.start_fuel_consume_rate
	$Player.pause_player = false
	$Player.is_SDC_full = false

func _on_HUD_game_start_click():
	$HUD.start_game_process()
	setup_player_game_start()
