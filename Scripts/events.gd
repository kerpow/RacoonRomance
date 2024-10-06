extends Node

signal player_caught();
signal player_at_spawn();
signal player_shiny_collected();
signal shineys_updated(current : int, max : int)


signal player_light_change(is_illuminated : bool)
signal player_hidden()
signal player_stamina_update(stamina : float, max_stamina: float)
signal player_move_begin()
signal player_move_end()

signal human_alert_begin()
signal human_alert_end()

signal rummage_begin(trash_can : TrashCan)
signal rummage_update(trash_can : TrashCan)
signal rummage_success(trash_can : TrashCan)
signal rummage_fail(trash_can : TrashCan)
signal rummage_end(trash_can : TrashCan)

signal game_request_next_level()
signal game_request_restart_level()
signal game_request_lose_scene()
signal game_level_closing()
signal game_request_restart_game()
