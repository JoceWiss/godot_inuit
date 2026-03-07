extends Node
class_name Inventaire
signal donner_poids_total(valeur)
signal inventaire_modifie(valeur)
var slots_sac : Array = []
var slots_equipement : Dictionary = {
	"tete": null,
	"main_droite": null,
	"main_gauche": null,
	"torse": null,
	"dos": null,
	"ceinture": null,
	"jambes": null,
	"pieds": null,
	"sac":null
}


var poids_total : float = 0.0 :
	set(valeur) :
		poids_total = valeur
		donner_poids_total.emit(poids_total)
	
	

func ajouter_objet(objet_a_ajouter : Objet) -> bool:
	var copie = objet_a_ajouter.duplicate()
	slots_sac.append(copie)
	calculer_poids()
	inventaire_modifie.emit()
	return true



func retirer_objet(objet: Objet,depuis_le_sac: Objet = null):
	if depuis_le_sac:
		depuis_le_sac.contenu.erase(objet)
	else:
		for slot in slots_equipement:
			if slots_equipement[slot] == objet:
				slots_equipement[slot] = null
				break
	calculer_poids()
	

func calculer_poids() -> float:
	var cumul : float = 0.0
	for slot in slots_equipement.values():
		if slot != null:
			cumul += _calculer_poids_recursif(slot)
	for objet in slots_sac:
		if objet !=null:
			cumul +=_calculer_poids_recursif(objet)
			
	poids_total = cumul	
	return poids_total

func _calculer_poids_recursif(objet:Objet) -> float :
	var p = objet.poids
	if objet.est_un_conteneur:
		for sous_objet in objet.contenu:
			p += _calculer_poids_recursif(sous_objet)
	return p	
	 
