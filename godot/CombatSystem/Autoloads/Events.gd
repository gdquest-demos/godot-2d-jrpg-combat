# Event bus for distant nodes to communicate using signals.
# This is intended for cases where connecting the nodes directly creates more coupling
# or increases code complexity substantially.
extends Node


# Emitted when hovering a UIActionButton. The UIBattlerHUD uses this to display a preview of an
# action's energy cost.
signal combat_action_hovered(display_name, energy_cost)
# Emitted during a player's turn, when they chose an action and validated their target.
signal player_target_selection_done
