# Event bus for distant nodes to communicate using signals.
# This is intended for cases where connecting the nodes directly creates more coupling
# or increases code complexity substantially.
extends Node


signal combat_action_hovered(energy_cost)
signal player_target_selection_done
