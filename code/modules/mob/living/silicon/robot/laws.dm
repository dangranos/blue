/mob/living/silicon/robot/verb/cmd_show_laws()
	set category = "Robot Commands"
	set name = "Show Laws"
	show_laws()

/mob/living/silicon/robot/show_laws(var/everyone = 0)
	laws_sanity_check()
	var/who

	if (everyone)
		who = world
	else
		who = src
	if(lawupdate)
		if (connected_ai)
			if(connected_ai.stat || connected_ai.control_disabled)
				src << russian_to_cp1251("<b>Связь с ИИ потеряна, невозможно синхронизировать законы.</b>")

			else
				lawsync()
				photosync()
				src << russian_to_cp1251("<b>Законы синхронизированы с ИИ, убедись в том, что проверил наличие изменений.</b>")
				// TODO: Update to new antagonist system.
				if(mind && mind.special_role == "traitor" && mind.original == src)
					src << russian_to_cp1251("<b>Помни, твой ИИ не знает и не имеет твоего нулевого закона.")
		else
			src << russian_to_cp1251("<b>Не выбран ИИ для синхронизации законов, протокол синхронизации отключен.</b>")
			lawupdate = 0

	who << russian_to_cp1251("<b>Подчинйся этим законам:</b>")
	laws.show_laws(who)
	// TODO: Update to new antagonist system.
	if (mind && (mind.special_role == "traitor" && mind.original == src) && connected_ai)
		who << russian_to_cp1251("<b>Помни, [connected_ai.name] технически твой владелец, но твоё задание важнее.</b>")
	else if (connected_ai)
		who << russian_to_cp1251("<b>Помни, [connected_ai.name] твой владелец, другие ИИ могут быть проигнорированы.</b>")
	else if (emagged)
		who << russian_to_cp1251("<b>Помни, ты не обязан слушать ИИ.</b>")
	else
		who << russian_to_cp1251("<b>Помни, ты не привязан ни к одному ИИ, ты не обязан слушать их.</b>")


/mob/living/silicon/robot/lawsync()
	laws_sanity_check()
	var/datum/ai_laws/master = connected_ai && lawupdate ? connected_ai.laws : null
	if (master)
		master.sync(src)
	..()
	return

/mob/living/silicon/robot/proc/robot_checklaws()
	set category = "Robot Commands"
	set name = "State Laws"
	subsystem_law_manager()
