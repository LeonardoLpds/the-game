extends "res://Characters/Character.gd"

onready var sprite = $AnimatedSprite
onready var hurtbox = $Hurtbox/CollisionShape2D

func _init():
	self.vit = 5
	
func _ready():
	sprite.play("Idle")

func _on_Hurtbox_area_entered(area):
	sprite.play("Hurt")
	var damage = area.damage if "damage" in area else 1
	hurt(damage)
	yield(sprite, "animation_finished")
	sprite.play("Idle")
	

func _on_Enemy_no_hp():
	sprite.play("Die")
	hurtbox.set_deferred("disabled", true)
	sprite.stop()
