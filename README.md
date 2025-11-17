# Higher / Lower

## Description
First 'Game' in my collection of 'Learning Godot & Game Dev' creations

This game is buggy, but functional.

First, we create a Deck.
We assign a hand for the player and a hand for the enemy.

The player can play 1 of his cards versus a random one of the enemy

If it's higher, you win, if it's lower, you lose.


## Lessons Learned
- Godot Basic
- Area2D / CollisionShape2D / Sprite2D
- Signals (with and without SignalBus)
- Component Architecture (SlotComponent, DraggableComponent)
	- These 'Components' can be slotted anywhere. Are developped to be agnostic (except for having a required parent node)
- Autoloads -> Essentially, these are 'Global' scripts that can be used anywhere without having to have a reference to it's node in the scene
	- Have to be defined in the Project Settings -> Globals
