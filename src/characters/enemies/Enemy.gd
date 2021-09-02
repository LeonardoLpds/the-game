extends "res://src/characters/Character.gd"

onready var sprite = $AnimatedSprite
onready var hurtbox = $Hurtbox/CollisionShape2D
onready var playerDetectionZone = $PlayerDetectionZone
onready var smoke = preload("res://src/effects/Smoke.tscn")

export var aggressive = true
export var walk_speed = 50
export var acceleration = 5
var velocity = Vector2.ZERO

enum {IDLE, WANDER, CHASE, ATTACK, HURT}
var state = IDLE

func _physics_process(delta):
	match state:
		IDLE:
			sprite.play("Idle")
			velocity = move_and_slide(velocity.move_toward(Vector2.ZERO, acceleration))
			_seek_player()
		WANDER:
			pass
		CHASE:
			sprite.play("Walk")
			if !playerDetectionZone.can_see_player():
				state = IDLE
				return
			var player = playerDetectionZone.player
			var direction = (player.global_position - global_position).normalized()
			velocity = velocity.move_toward(direction * walk_speed, acceleration)
		ATTACK:
			pass
		HURT:
			velocity = Vector2.ZERO
			sprite.play("Hurt")
			yield(sprite, "animation_finished")
			state = IDLE
			
	sprite.flip_h = velocity.x < 0
	velocity = move_and_slide(velocity)
			
func _seek_player():
	if playerDetectionZone.can_see_player():
		state = CHASE

func _on_Hurtbox_area_entered(area):
	var damage = area.damage if "damage" in area else 1
	hurt(damage)
	state = HURT
	

func _on_Enemy_no_hp():
	hurtbox.set_deferred("disabled", true)
	sprite.play("Die")
	sprite.stop()
	_death_effect()
	
func _death_effect():
	var smokeInstance = smoke.instance()
	get_tree().current_scene.add_child(smokeInstance)
	smokeInstance.global_position = global_position
	queue_free()
