class_name EventQueue extends Node

signal finished()
signal event_ran()

enum Actions {
	HIT,
	TRICK,
	STAND,
	FOLD
}

var list: Array = []

func run_event() -> void:
	if !list:
		finished.emit()
		return
	var event: Array = list.pop_front()
	var actor: BattleActor = event[0]
	var target: BattleActor = event[1]
	var action: String = event[2]
	if !actor:
		finished.emit()
		return
	
	match action:
			"HIT":
				print(actor.name + " hits " + target.name + "!")
				target.healhurt(int(-actor.power))
			"TRICK":
				print(actor.name + " does a trick!")
			"STAND":
				print(actor.name + " stands!")
			"FOLD":
				print(actor.name + " folds!")
			_:
				print(actor.name + " does nothing!")
	await get_tree().create_timer(GlobalScript.DEFAULT_TIMER).timeout
	
	if list.front():
		if !actor || !actor.can_act():
			run_event()
		actor.act()
		await get_tree().create_timer(GlobalScript.DEFAULT_TIMER).timeout
	event_ran.emit(actor)
	run_event()

func add_event(caller: BattleActor, target: BattleActor, action: String) ->void:
	list.append([caller,target,action])

func add_hit(caller: BattleActor, target: BattleActor) ->void:
	add_event(caller,target,"HIT")

func add_trick(caller: BattleActor, target: BattleActor) ->void:
	add_event(caller,target,"TRICK")

func add_fold(caller: BattleActor, target: BattleActor) ->void:
	add_event(caller,target,"FOLD")

func add_stand(caller: BattleActor, target: BattleActor) ->void:
	add_event(caller,target,"STAND")
