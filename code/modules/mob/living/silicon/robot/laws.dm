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
				src << russian_to_cp1251("<b>����� � �� ��������, ���������� ���������������� ������.</b>")

			else
				lawsync()
				photosync()
				src << russian_to_cp1251("<b>������ ���������������� � ��, ������� � ���, ��� �������� ������� ���������.</b>")
				// TODO: Update to new antagonist system.
				if(mind && mind.special_role == "traitor" && mind.original == src)
					src << russian_to_cp1251("<b>�����, ���� �� �� ����� � �� ����� ������ �������� ������.")
		else
			src << russian_to_cp1251("<b>�� ������ �� ��� ������������� �������, �������� ������������� ��������.</b>")
			lawupdate = 0

	who << russian_to_cp1251("<b>��������� ���� �������:</b>")
	laws.show_laws(who)
	// TODO: Update to new antagonist system.
	if (mind && (mind.special_role == "traitor" && mind.original == src) && connected_ai)
		who << russian_to_cp1251("<b>�����, [connected_ai.name] ���������� ���� ��������, �� ��� ������� ������.</b>")
	else if (connected_ai)
		who << russian_to_cp1251("<b>�����, [connected_ai.name] ���� ��������, ������ �� ����� ���� ���������������.</b>")
	else if (emagged)
		who << russian_to_cp1251("<b>�����, �� �� ������ ������� ��.</b>")
	else
		who << russian_to_cp1251("<b>�����, �� �� �������� �� � ������ ��, �� �� ������ ������� ��.</b>")


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
