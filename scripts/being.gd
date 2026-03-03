extends CharacterBody2D
class_name Being
@export_group("pv")
@export var pv_max : float = 100
signal pv_mise_a_jour(valeur)

var pv_actuels : float = 100.0:
	set(valeur):
		pv_actuels = clamp(valeur,0,pv_max)
		pv_mise_a_jour.emit(pv_actuels)
		if pv_actuels <= 0:
			emit_signal("etat_vie_change",false)
			mourir()
		else :
			emit_signal("etat_vie_change",true)

signal etat_vie_change(est_vivant)

func _ready():
	pv_actuels = pv_max
func mourir():
	pass		
		
