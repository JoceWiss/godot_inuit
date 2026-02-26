extends CharacterBody2D
class_name Human
signal faim_mise_a_jour(valeur)
signal pv_mise_a_jour(valeur)

@export var pv_max = 100
@export var faim_max = 100

var pv_actuels : float
var faim_actuelle : float



func _ready():
	pv_actuels = pv_max
	faim_actuelle = faim_max
func _modifier_pv(valeur:float):
	pv_actuels += valeur
	pv_actuels = clamp(pv_actuels,0,pv_max)
	if pv_actuels < 0 :
		print("Game over")	
	faim_mise_a_jour.emit(pv_actuels)	
func _modifier_faim(valeur:float):
	faim_actuelle += valeur
	faim_actuelle = clamp(faim_actuelle,0,faim_max)
	if faim_actuelle < 0 :
		_modifier_pv(valeur)
	faim_mise_a_jour.emit(faim_actuelle)
				
