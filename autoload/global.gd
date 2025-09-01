extends Node
#@export var speed = 400

@export var score: int = 0

var high_scores := []  # Array of dictionaries: { "name": "ABC", "score": 123 }

func _ready():
	print("Preparing high scores")
	add_score("BOB", 100000)
	add_score("BOB", 50000)
	add_score("BOB", 35000)
	add_score("BOB", 20000)
	add_score("BOB", 15000)
	add_score("BOB", 10000)
	add_score("BOB", 8000)
	add_score("BOB", 4000)
	add_score("BOB", 2000)
	add_score("BOB", 1000)

func add_score(name: String, new_score: int) -> void:
	high_scores.append({ "name": name, "score": new_score })
	#print(high_scores)
	high_scores.sort_custom(sort_scores_desc)
	#print(high_scores)
	if high_scores.size() > 10:
		high_scores.resize(10)
 
func sort_scores_desc(a, b):
	return b["score"] < a["score"]
