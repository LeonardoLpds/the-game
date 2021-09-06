extends "res://src/characters/Character.gd"

# Ready
onready var animationTree = $AnimationTree
onready var animationState = animationTree.get("parameters/playback")
onready var weaponSprite = $WeaponSprite

# State machine
enum { MOVE, ATTACK }
var state = MOVE

# Move variables
const WALK_SPEED = 100
const ACCELERATION = 15
var velocity = Vector2.ZERO

# Equips
var weapon: Weapon setget set_weapon

func _ready():
	self.weapon = load("res://assets/art/weapons/Iron Sword.tres")

func _physics_process(_delta):
	match state:
		MOVE:
			move_state()
		ATTACK:
			attack_state()
			
func move_state():
	var x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	var y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	var input = Vector2(x, y).normalized()
	
	velocity = move_and_slide(velocity.move_toward(input * WALK_SPEED, ACCELERATION))
	
	if input != Vector2.ZERO:
		animationState.travel("Run")
		for animation in ["Idle", "Run"]:
			animationTree.set("parameters/"+animation+"/blend_position", input)
		
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

func set_weapon(new_weapon: Weapon):
	weapon = new_weapon
	weaponSprite.texture = weapon.texture
	animationTree.set("parameters/Attack/Weapon/current", weapon.type)
	self.attack += weapon.attack


func _on_Hurtbox_area_entered(area):
	hurt(area.damage if "damage" in area else 1)


func _on_Player_no_hp():
	queue_free()
