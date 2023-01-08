extends Area2D

export var dust_value = 20

# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimatedSprite.play()

func _on_SpaceDust_area_entered(area):
	if !area.get_parent().is_SDC_full:
		hide()
		$CollisionShape2D.set_deferred("disabled", true)
	
func level_reset():
	show()
	$CollisionShape2D.set_deferred("disabled", false)
