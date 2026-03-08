extends Creature
class_name Human
signal faim_mise_a_jour(valeur)
signal capacite_emport_mise_a_jour(valeur)
@export_group("vitesse")
@export var vitesse_marche = 400.0
@export var vitesse_course = 800.0
@export_group("gestion de la faim")
#variables pour gérer la faim en fonction de l'activité
@export var vitesse_faim_marche = -0.5
@export var vitesse_faim_course = -1
@export var vitesse_faim = -0.2
#affaiblissement quand la faim n'est pas satisfaite
@export var vitesse_affaiblissement = -0.2

#pathfinding
@onready var nav_agent = $NavigationAgent2D

#zoom

@onready var camera = $Camera2D
@onready var animation_player = $Sprite2D/AnimationPlayer
@onready var sprite_2d = $Sprite2D
@export_group("signes vitaux")
@export var faim_max = 100

@export_group ("compétences humaines")
@export var orientation : int

@export var objet_au_sol_scene : PackedScene
@onready var inventaire_manager: Inventaire = $inventaire

@onready var inventaire = $inventaire
#Ralentissement
var cible = Vector2.ZERO #l'endroit ou on veut aller
var vitesse_actuelle = 400.0 #vtesse en cours
var objet_a_ramasser = null #objet à ramasser null jusque preuve du contraire
var distance_interaction = 200.0 #distance à laquelle on va s'arrêter pour prendre un objet

#setter de faim
var faim_actuelle: float = 100.0:
	set(valeur):
		faim_actuelle = clamp(valeur,0,faim_max)
		
		faim_mise_a_jour.emit(faim_actuelle)


func _ready():
	faim_actuelle = faim_max
	print("verification demarrage")
	if objet_au_sol_scene == null:
		print("Scene null")
	else: print("scene chargée")
	
	super()

func calculer_modificateur_vitesse() -> float :
	var capacite_emport = (force/2.0)**2
	var p = inventaire.poids_total
	if capacite_emport <= 0: return 0.1
	return exp(-(p/capacite_emport))

	
	

func _physics_process(delta: float) -> void:

	if velocity.length() < 5:
		self.faim_actuelle += vitesse_faim*delta
		
	elif vitesse_actuelle == vitesse_course :
		self.faim_actuelle += vitesse_faim_course*delta
		
	else :
		self.faim_actuelle += vitesse_faim_marche*delta
	
	#pv qui diminue avec la faim
	if self.faim_actuelle <= 0:
		self.pv_actuels += vitesse_affaiblissement*delta
	if objet_a_ramasser != null:
		finaliser_ramassage()
				
#déplacement pour ramassage d'objet	
func aller_ramasser(objet):
	objet_a_ramasser= objet
	cible = objet.global_position 
func finaliser_ramassage():
	if objet_a_ramasser != null	:
		var distance = global_position.distance_to(objet_a_ramasser.global_position)
		if distance <= distance_interaction:
			print("objet ramassé !")
			var resource = objet_a_ramasser.objet_data
			if inventaire.ajouter_objet(resource):
				objet_a_ramasser.queue_free()
				objet_a_ramasser = null
				cible = global_position
			else: print("inventaire plein")
			
func lacher_objet(objet: Objet, sac_source: Objet = null):
	if objet_au_sol_scene == null:
		push_error("ERREUR : Le nœud " + name + " essaie de lâcher un objet mais sa variable est vide !")
		return
	inventaire.retirer_objet(objet, sac_source)
	  
	var instance = objet_au_sol_scene.instantiate()
	var dossier_objet = get_parent().get_node("objet_au_sol")
	dossier_objet.add_child(instance)
	instance.item_data = objet
	instance.global_position = global_position + Vector2(50,0)
	
	
		
	
	
