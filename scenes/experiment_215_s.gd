extends Node2D

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var playback = $AnimationTree.get("parameters/StateMachine/playback")
@onready var animation_tree: AnimationTree = $AnimationTree
@onready var health_ressources: GameResource = $HealthRessources
var trigger : Trigger


var is_dead
var facing_direction : float = 1.0
enum BossState { IDLE, DECOLLAGE, EN_VOL, ATTERRISSAGE }
var current_state = BossState.IDLE

var idle_finished_count : int = 0
var movement_timer : float = 0.0
const MOVEMENT_DURATION : float = 10.0
const SPEED : float = 120.0

func _ready() -> void:
	health_ressources.is_dead.connect(_on_boss_death)

func set_trigger(scene_trigger : Trigger) -> void:
	trigger = scene_trigger

func _physics_process(delta: float) -> void:
	if current_state == BossState.EN_VOL:
		movement_timer += delta
		if %Visual.scale.x == 1:
			global_position.x -= SPEED * delta
		else:
			global_position.x += SPEED * delta
		if movement_timer >= MOVEMENT_DURATION:
			commencer_atterrissage()

	%Visual.scale.x = abs(%Visual.scale.x) * facing_direction


func _on_decollage_termine() -> void:
	movement_timer = 0.0
	current_state = BossState.EN_VOL
	
func commencer_atterrissage() -> void:
	current_state = BossState.ATTERRISSAGE
	if current_state == BossState.IDLE:
		return
	
	facing_direction *= -1
	playback.start("possesed_reverse")

func _on_atterrissage_termine() -> void:
	if current_state == BossState.IDLE:
		return
	current_state = BossState.IDLE
	
	
	playback.travel("Idle 2")

func _on_boss_death() -> void:
	if is_dead:
		return
	is_dead  = true
	if has_node("Visual/Drops/DropTimer"): $Visual/Drops/DropTimer.stop()
	$Area2D/CollisionShape2D.set_deferred("disabled",true)
	set_process(false)
	set_physics_process(false)
	trigger.save()
	


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if current_state != BossState.IDLE:
		return
		
	if anim_name == "Idle":
		idle_finished_count += 1
		if idle_finished_count >= 2:
			animation_tree.set("parameters/StateMachine/conditions/is_idle_finished", true)
			idle_finished_count = 0
	else:
		animation_tree.set("parameters/StateMachine/conditions/is_idle_finished", false)
