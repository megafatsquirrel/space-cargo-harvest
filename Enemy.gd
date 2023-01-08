extends Area2D

signal enemy_hit_player

export var speed = 350
export var steer_force = 50.0

export var damage = 10

var velocity = Vector2.ZERO
var acceleration = Vector2.ZERO
var target = null

func start(_transform, _target):
	global_transform = _transform
	#rotation += rand_range(-0.09, 0.09)
	#velocity = transform.x * speed
	#target = _target

func seek():
	var steer = Vector2.ZERO
	if target:
		var desired = (target.position - position).normalized() * speed
		steer = (desired - velocity).normalized() * steer_force
	return steer
	
func _physics_process(delta):
	acceleration += seek()
	velocity += acceleration * delta
	velocity = velocity.clamped(speed)
	rotation = velocity.angle()
	position += velocity * delta

func explode():
	#$Particles2D.emitting = false
	#set_physics_process(false)
	#$AnimationPlayer.play("explode")
	#yield($AnimationPlayer, "animation_finished")
	queue_free()
	
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _on_Enemy_body_entered(body):
	explode()
	hide() #enemy disappears after hitting something
	#check if player type
	if body.get_name() == "Player":
		emit_signal("enemy_hit_player") #check if the player was hit
		$CollisionShape2D.set_deferred("disabled", true)


# enter area to get enemy to start following
func _on_alert_area_body_entered(body):
	if body.get_name() == "Player":
		target = body
