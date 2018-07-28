extends VBoxContainer

var option = 0
var options = {
    App.PLAYER_VS_PLAYER: 'Player VS Player',
    App.PLAYER_VS_CPU: 'Player VS CPU',
    App.CPU_VS_CPU: 'CPU VS CPU'
}

onready var labels = {
    App.PLAYER_VS_PLAYER: $pvp,
    App.PLAYER_VS_CPU: $pvc,
    App.CPU_VS_CPU: $cvc
}

func _ready():
    _update_options()

func _input(event):
    if event.is_action_pressed('ui_up'):
        option -= 1
        _update_options()
    elif event.is_action_pressed('ui_down'):
        option += 1
        _update_options()
    elif event.is_action_pressed('ui_accept'):
        App.game_mode = option
        get_tree().change_scene('res://scenes/game/game.tscn')

func _update_options():
    option = clamp(option, 0, options.size() - 1)

    for k in options:
        labels[k].text = options[k]

    labels[option].text = '>' + options[option] + '<'
