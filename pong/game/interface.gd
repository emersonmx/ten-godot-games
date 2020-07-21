extends Control


func _ready():
	pass


func update_player1_score(score):
	$'scoreboard/hbox/score_1'.text = str(score)


func update_player2_score(score):
	$'scoreboard/hbox/score_2'.text = str(score)
