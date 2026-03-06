extends Node
class_name Inventaire
signal donner_poids_total(valeur)

var slots_equipement : Dictionary = {
	"tete": null,
	"main_droite": null,
	"main_gauche": null,
	"torse": null,
	"dos": null,
	"ceinture": null,
	"jambes": null,
	"pieds": null,
}


var poids_total : float = 0.0 :
	set(valeur) :
		poids_total = valeur
		donner_poids_total.emit(poids_total)
	
func trouver_sac_disponible() :
	var slots_potentiels = ["dos","main_droite","main_gauche","ceinture"]
	for nom_slot in slots_potentiels : 
		var objet_equipe = slots_equipement[nom_slot]
		if objet_equipe != null and objet_equipe.est_un_conteneur:
			if objet_equipe.contenu.size() < objet_equipe.capacite_max:
				return objet_equipe
	return null

func ajouter_objet(objet_a_ajouter : Objet) -> bool:
	var copie = objet_a_ajouter.duplicate()
	var a_ete_range : bool = false
	if slots_equipement["main_droite"] == null:
		slots_equipement["main_droite"] = copie
		a_ete_range = true
	elif slots_equipement["main_gauche"]  == null:
		slots_equipement["main_gauche"] = copie
		a_ete_range = true
	var sac_disponible = trouver_sac_disponible()
	if sac_disponible != null :
		sac_disponible.contenu.append(copie)
		print(objet_a_ajouter.nom, "ajouté dans", sac_disponible.nom)
		a_ete_range = true
	if a_ete_range == true:
		calculer_poids()
		return true
	else : return false
	
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
			
	poids_total = cumul	
	return poids_total

func _calculer_poids_recursif(objet:Objet) -> float :
	var p = objet.poids
	if objet.est_un_conteneur:
		for sous_objet in objet.contenu:
			p += _calculer_poids_recursif(sous_objet)
	return p	
	 
