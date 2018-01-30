# Coin.gd

extends Area2D

func _ready():
    connect("body_entered", self, "_on_body_entered")
    pass

func _on_body_entered(other_body):
    if other_body.is_in_group(Game.GROUP_BIRDS):
        # Increase score.
        Game.score_current += 1
        AudioPlayer.play_stream(AudioPlayer.POINT_STREAM)
    pass
