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
	self.pv_actuels = self.pv_max
	self.faim_actuelle = self.faim_max


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
				
func calcul_modificateur(nom_stat: String) -> int:
	var score = get(nom_stat)
	if score == null:
		score = 0
	return (score - 10) / 2

	
		
	
	
