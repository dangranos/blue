/datum/job/assistant
	title = "Assistant"
	flag = ASSISTANT
	department = "Civilian"
	department_flag = CIVILIAN
	faction = "Station"
	total_positions = -1
	spawn_positions = -1
	supervisors = "absolutely everyone"
	selection_color = "#dddddd"
	access = list()			//See /datum/job/assistant/get_access()
	minimal_access = list()	//See /datum/job/assistant/get_access()
	alt_titles = list("Technical Assistant","Medical Intern","Research Assistant","Visitor")

	uniform = /obj/item/clothing/under/color/grey
	pda = /obj/item/device/pda
	ear = /obj/item/device/radio/headset
	shoes = /obj/item/clothing/shoes/black


/datum/job/assistant/get_access()
	return list(access_maint_tunnels)
