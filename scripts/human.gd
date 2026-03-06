extends Creature
class_name Human
signal faim_mise_a_jour(valeur)
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

var inventaire : Inventaire

#poids
var capacite_emport = (force/2)**2
var poids_total

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
	
	super()

func _physics_process(delta: float) -> void:
	if vitesse_actuelle == vitesse_course:
		animation_player.play("course")
	if vitesse_actuelle == vitesse_marche:
		animation_player.play("marche")
		#système de faim
	if velocity.length() < 5:
		self.faim_actuelle += vitesse_faim*delta
		
	elif vitesse_actuelle == vitesse_course :
		self.faim_actuelle += vitesse_faim_course*delta
		
	else :
		self.faim_actuelle += vitesse_faim_marche*delta
	
	#pv qui diminue avec la faim
	if self.faim_actuelle <= 0:
		self.pv_actuels += vitesse_affaiblissement*delta
				
#déplacement pour ramassage d'objet	
func aller_ramasser(objet):
	objet_a_ramasser= objet
	cible = objet.global_position 
func finaliser_ramassage():
	if objet_a_ramasser != null	:
		var distance = global_position.distance_to(objet_a_ramasser.global_position)
		if distance <= distance_interaction:
			print("objet ramassé !")
			var resource = objet_a_ramasser.item_data
			if inventaire.ajouter_objet(resource):
				objet_a_ramasser.queue_free()
				objet_a_ramasser = null
				cible = global_position
			else: print("inventaire plein")

func lacher_objet(objet: Objet, sac_source: Objet = null):
	inventaire.retirer_objet(objet, sac_source)
	 
	var instance = objet_au_sol_scene.instantiate()
	var dossier_objet = get_parent().get_node("objet_au_sol")
	dossier_objet.add_child(instance)
	instance.item_data = objet
	instance.global_position = global_position + Vector2(50,0)
	
	
		
	
	
