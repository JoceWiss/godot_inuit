extends Resource
class_name Objet

enum Type {ARME, OUTIL, VETEMENT, NOURRITURE, PROIE}

@export_group("General")
@export var nom : String =""
@export var type_objet : Type = Type.OUTIL
@export var icone : Texture2D

@export_group("Poids")
@export var poids : float = 1.0
@export var poids_marge_aleatoire: float = 0.0

@export_group("Armes")
@export var formule_degats : String = "1d6"

@export_group("Nourriture")
@export var valeur_nutritive : float=1
