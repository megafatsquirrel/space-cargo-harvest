extends CanvasLayer

signal sum_confirm_click
signal thrust_purchased
signal upgrade_confirm_click
signal game_start_click

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func start_game_process():
	$StartMenuLabel.visible = false;

func update_spaceDustCargo(SDC):
	$SpaceDustCargoLabel.text = str("Space Dust Cargo: ", SDC)

func update_fuel(fuel):
	$FuelLabel.text = str("Fuel: ", fuel)

func update_velocity(vel):
	$VelocityLabel.text = str("Velocity: ", vel)
	
func update_money(money):
	$PlayerMoneyLabel.text = str("Money: $ ", money)

func update_debt(debt):
	$PlayerDebtLabel.text = str("Debt: $ ", debt)

func update_sum_sd(sd, rate, total):
	$SummaryLabel/SDLabel.text = str("Special Space Dust: ", sd) # sd * rate = amount of cash
	$SummaryLabel/SDLabel/SDRateLabel.text = str("x ", rate)
	$SummaryLabel/SDLabel/SDTotal.text = str("= ", total)
	
func update_sum_fuel(fuel, cost, total):
	$SummaryLabel/FuelUsedLabel.text = str("Fuel Used: ", fuel)
	$SummaryLabel/FuelUsedLabel/FuelCostLabel.text = str("x ", cost)
	$SummaryLabel/FuelUsedLabel/FuelTotalLabel.text = str("= ", total)

func update_sum_debt(debt, payment, remaining):
	$SummaryLabel/DebtLabel.text = str("Debt Remaining: ", debt)
	$SummaryLabel/DebtLabel/MinDebtPaymentLabel.text = str("- ", payment)
	$SummaryLabel/DebtLabel/RemainingDebtLabel.text = str("= ", remaining)

func update_sum_earned(earned, fees, total):
	$SummaryLabel/MoneyEarnedLabel.text = str("Money Earned: ", earned)
	$SummaryLabel/MoneyEarnedLabel/FeesLabel.text = str("- ", fees)
	$SummaryLabel/MoneyEarnedLabel/TotalMoneyEarnedLabel.text = str("= ", total)
	
func update_upgrade_money(money):
	$UpgradeLabel/PlayerMoneyLabel.text = str("Money: ", money)

func _on_ConfimButton_pressed():
	emit_signal("sum_confirm_click")


func _on_UpgradeConfirmButton_pressed():
	emit_signal("upgrade_confirm_click")


func _on_BuyThrustButton_pressed():
	emit_signal("thrust_purchased")


func _on_GameStartButton_pressed():
	emit_signal("game_start_click")
