extends Node2D

onready var sprite = $AnimatedSprite
onready var hurtbox = $Hurtbox/CollisionShape2D

func _on_Hurtbox_area_entered(_area):
	hurtbox.set_deferred("disabled", true)
	sprite.play("Cut")
