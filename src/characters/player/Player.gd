extends "res://src/characters/Character.gd"

# Ready
onready var animationTree = $AnimationTree
onready var animationState = animationTree.get("parameters/playback")
onready var weaponSprite = $WeaponSprite
onready var hitbox = $HitboxPivot/Hitbox

# State machine
enum { MOVE, ATTACK, HURT, DIE }
var state = MOVE

# Move variables
const WALK_SPEED = 100
const ACCELERATION = 15
var velocity = Vector2.ZERO

# Equips
export(Resource) var weapon setget set_weapon
export(Resource) var equips

func _physics_process(_delta):
	match state:
		MOVE:
			move_state()
		ATTACK:
			attack_state()
		HURT:
			hurt_state()
		DIE:
			die_state()

# States
func move_state():
	var x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	var y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	var input = Vector2(x, y).normalized()
	
	velocity = move_and_slide(velocity.move_toward(input * WALK_SPEED, ACCELERATION))
	
	if input != Vector2.ZERO:
		animationState.travel("Run")
		for animation in ["Idle", "Run", "Hurt"]:
			animationTree.set("parameters/"+animation+"/blend_position", input)
		animationTree.set("parameters/Die/blend_position", input.x)
		
		if (weapon):
			animationTree.set("parameters/Attack/"+str(weapon.type)+"/blend_position", input)
	else:
		animationState.travel("Idle")
		
	if Input.is_action_just_pressed("attack"):
		state = ATTACK

func attack_state():
	velocity = Vector2.ZERO
	animationState.travel("Attack")
	
func reset_state():
	state = MOVE

func hurt_state():
	velocity = Vector2.ZERO
	animationState.travel("Hurt")

func die_state():
	velocity = Vector2.ZERO
	set_physics_process(false)
	animationState.travel("Die")

# Helpers
func set_weapon(new_weapon: Weapon):
	call_deferred("_set_weapon", new_weapon)

func _set_weapon(new_weapon):
	weapon = new_weapon
	weaponSprite.texture = weapon.texture
	animationTree.set("parameters/Attack/Weapon/current", weapon.type)
	self.attack += weapon.attack
	
# Signals
func _on_Player_no_hp():
	state = DIE

func _on_Player_attack_change():
	call_deferred("_set_hitbox_damage");

func _set_hitbox_damage():
	hitbox.damage = self.attack

func _on_Player_hurt():
	state = HURT
