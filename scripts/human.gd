extends Being
class_name Human
signal faim_mise_a_jour(valeur)
signal pv_mise_a_jour(valeur)
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
var cible = Vector2.ZERO #l'endroit ou on veut aller

#pathfinding
@onready var nav_agent = $NavigationAgent2D
#zoom
@onready var camera = $Camera2D
@onready var animation_player = $Sprite2D/AnimationPlayer
@onready var sprite_2d = $Sprite2D

@export_group("signes_vitaux")
@export var pv_max = 100
@export var faim_max = 100

@export_group("caracteristiques")
@export var dexterite : int
@export var endurance : int
@export var force : int
@export var orientation : int

var vitesse_actuelle = 400.0
var objet_a_ramasser = null
var distance_interaction = 200.0

var pv_actuels : float = 100.0:
	set(valeur):
		pv_actuels=clamp(valeur,0,pv_max)
		pv_mise_a_jour.emit(pv_actuels)


var faim_actuelle: float = 100.0:
	set(valeur):
		faim_actuelle = clamp(valeur,0,faim_max)
		
		faim_mise_a_jour.emit(faim_actuelle)


func _ready():
	self.pv_actuels = pv_max
	self.faim_actuelle = faim_max


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

	
		
	
	
