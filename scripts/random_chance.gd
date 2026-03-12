class_name RandomChance
extends Node

signal number_generated(number:int)
signal luck_generated(luck:int)
signal chance_generated(chance:int)

@export var dice_faces := 6
@export_range(0.0, 1.0, 0.01) var luck_threshold := 0.0

var number := 0
var chance := 0.0
var luck := 0.0

var random_number_generator := RandomNumberGenerator.new()

func throw_dice() -> void:
	random_number_generator.randomize();
	number = random_number_generator.randi_range(1,dice_faces)
	chance = 1.0 / dice_faces
	luck = chance * number
	
	number_generated.emit(number)
	luck_generated.emit(luck)
	chance_generated.emit(chance)
