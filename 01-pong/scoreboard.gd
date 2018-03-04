extends Control

var scores = {
    1: 0, 2: 0
}

func _update_scores():
    $player1.text = str(scores[1])
    $player2.text = str(scores[2])

func _on_point(from_who):
    scores[from_who] += 1
    _update_scores()