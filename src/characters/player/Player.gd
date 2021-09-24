extends "res://src/characters/Character.gd"

# Ready
onready var animationTree = $AnimationTree
onready var animationState = animationTree.get("parameters/playback")
onready var weaponSprite = $WeaponSprite
onready var hitbox = $HitboxPivot/Hitbox
onready var spawnPivot = $HitboxPivot/SpawnPivot


# State machine
enum { MOVE, ATTACK, HURT, DIE }
var state = MOVE

# Move variables
const WALK_SPEED = 100
const ACCELERATION = 15
var velocity = Vector2.ZERO

# Equips
var weapon: Item setget set_weapon
export(Resource) var equips
var arrow = preload("res://src/items/scenes/Arrow.tscn")

func _ready() -> void:
	equips.connect("items_changed", self, "_on_equip_changed")
	#equips.set_item(3, Item.new("YAAi86AWspYOhT6boW1r"))
	
func _on_equip_changed(indexes: Array) -> void:
	if (indexes.has(3)):
		self.weapon = equips.items[3]
		
	

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
		
	if Input.is_action_just_pressed("attack") and weapon:
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
func set_weapon(new_weapon):
	weapon = new_weapon
	if (weapon is Item):
		weaponSprite.set_texture(weapon.animation)
		animationTree.set("parameters/Attack/Weapon/current", weapon.type - 1)
	else:
		weaponSprite.texture = null
		animationTree.set("parameters/Attack/Weapon/current", null)
	_set_hitbox_damage()
	
func spawn_arrow():
	var arrow_instance = arrow.instance()
	arrow_instance.global_position = spawnPivot.global_position
	arrow_instance.rotation = animationTree.get("parameters/Attack/"+str(weapon.type)+"/blend_position").angle()
	arrow_instance.damage = hitbox.damage
	get_parent().add_child(arrow_instance)

# Signals
func _on_Player_no_hp():
	state = DIE

func _on_Player_attack_change():
	call_deferred("_set_hitbox_damage");

func _set_hitbox_damage():
	hitbox.damage = self.attack + (weapon.attack if weapon else 0)

func _on_Player_hurt():
	state = HURT
