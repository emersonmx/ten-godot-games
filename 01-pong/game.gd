extends Node2D

var player_extents = Vector2(8, 24)
var player_script = preload('res://player.gd')
var player_ia_script = preload('res://player_ia.gd')

func _enter_tree():
    setupBall()

    if App.game_mode == App.PLAYER_VS_PLAYER:
        setupPvP()
    elif App.game_mode == App.PLAYER_VS_CPU:
        setupPvC()
    elif App.game_mode == App.CPU_VS_CPU:
        setupCvC()

func setupBall():
    var ball = $ball
    ball.top_wall = $top_wall
    ball.bottom_wall = $bottom_wall
    ball.player1 = $player1
    ball.player2 = $player2
    ball.game_area = get_viewport_rect()
    ball.connect('point', $'ui/scoreboard', '_on_point')

func setupPvP():
    var player1 = $player1
    var player2 = $player2

    player1.set_script(player_script)
    player1.extents = player_extents

    player2.set_script(player_script)
    player2.extents = player_extents

func setupPvC():
    var player1 = $player1
    var player2 = $player2

    player1.set_script(player_script)
    player1.extents = player_extents

    player2.set_script(player_ia_script)
    player2.extents = player_extents
    player2.ball = $ball

func setupCvC():
    var player1 = $player1
    var player2 = $player2
    var ball = $ball

    player1.set_script(player_ia_script)
    player1.extents = player_extents
    player1.ball = ball

    player2.set_script(player_ia_script)
    player2.extents = player_extents
    player2.ball = ball