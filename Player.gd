extends RigidBody2D

signal player_hit_spaceDust
signal player_update_fuel
signal player_fuel_empty
signal player_update_vel
signal player_SDC_full
signal player_hit_exit_area

var pause_player = true

export var money = 0.00
export var debt = 100000

#starting stats
export var start_sdc_max = 25
export var start_fuel_max = 500
export var start_fuel_consume_rate = 0.01
export var start_debt = 100000

export var SDC = 0
export var SDC_max = 100
var is_SDC_full = false
export var harvesting = false
export var fuel = 1000
export var fuel_max = 1000
export var fuel_consume_rate = 0.1
var fuel_empty = false;

export var engine_thrust = 200
export var spin_thrust = 500

var thrust = Vector2()
var rotation_dir = 0
var screensize

# change the .transform.origin.x of a rigidbody to update its position outside the phsyics engine

func _ready():
	screensize = get_viewport().get_visible_rect().size

func get_input():
	if Input.is_action_pressed("forward_thrust") && !fuel_empty:
		thrust = transform.y * -engine_thrust
		consume_fuel(fuel_consume_rate)
		$AnimatedSprite.animation = "thrust"
		$AnimatedSprite.play()
	elif Input.is_action_pressed("reverse_thrust") && !fuel_empty:
		# reverse is only half as good
		thrust = transform.y * (engine_thrust/2)
		consume_fuel(fuel_consume_rate)
		$AnimatedSprite.animation = "thrust"
		$AnimatedSprite.play()
	else:
		thrust = Vector2()
		$AnimatedSprite.animation = "default"
		$AnimatedSprite.stop()
	rotation_dir = 0
	if Input.is_action_pressed("rotate_right"):
		rotation_dir += 1
	if Input.is_action_pressed("rotate_left"):
		rotation_dir -= 1

func _process(delta):
	if (pause_player):
		# move to setting a game over state
		thrust = Vector2()
		rotation_dir = 0
		$AnimatedSprite.animation = "default"
		$AnimatedSprite.stop()
	else:	
		get_input()
		emit_signal("player_update_vel")

func _physics_process(delta):
	applied_force = thrust
	applied_torque = rotation_dir * spin_thrust

func consume_fuel(amount):
	if (fuel - amount <= 0):
		#game over - get towed back and zero out the space dust cargo
		fuel_empty = true
		emit_signal("player_fuel_empty")
	else:
		fuel -= amount
		emit_signal("player_update_fuel")

func handle_enemy_hit(damage):
	if SDC - damage >= 0:
		SDC -= damage
		emit_signal("player_hit_spaceDust")
	elif fuel - damage	>= 0:
		# check if there is a remainder of dust
		if SDC > 0:
			var remainder = damage - SDC
			consume_fuel(remainder)
		else:
			consume_fuel(damage)
	
func _on_ExitArea_body_entered(body):
	print("Exit Run")
	pause_player = true
	emit_signal("player_hit_exit_area") # add the summary screen and upgrade screen
	
	

func _on_HarvestArea_area_entered(area):
	if !is_SDC_full:
		update_SDC(area.dust_value)
		emit_signal("player_hit_spaceDust")
		$HarvestArea/AnimatedSprite.modulate.a = 1.0
		$HarvestTimer.start()

func _on_HarvestTimer_timeout():
	$HarvestArea/AnimatedSprite.modulate.a = 0.36

func update_SDC(amount):
	if SDC + amount < SDC_max: #Check for being under the max amount
		SDC += amount
	elif SDC + amount >= SDC_max:
		SDC = SDC_max #going over we set the max to the current SDC value
		is_SDC_full = true
		emit_signal("player_SDC_full")
