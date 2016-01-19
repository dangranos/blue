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
	alt_titles = list("Security Cadet","Technical Assistant","Medical Intern","Research Assistant","Visitor")

	uniform = /obj/item/clothing/under/color/grey
	pda = /obj/item/device/pda
	ear = /obj/item/device/radio/headset
	shoes = /obj/item/clothing/shoes/black

	equip(var/mob/living/carbon/human/H)
		if(!H)	return 0
		if (H.mind && H.mind.role_alt_title)
			switch(H.mind.role_alt_title)
				if("Security Cadet")
					H.equip_to_slot_or_del(new /obj/item/clothing/under/rank/security2(H), slot_w_uniform)
				if("Technical Assistant")
					H.equip_to_slot_or_del(new /obj/item/clothing/under/color/yellow(H), slot_w_uniform)
					H.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/hazardvest(H), slot_wear_suit)
				if("Medical Intern")
					H.equip_to_slot_or_del(new /obj/item/clothing/under/color/white(H), slot_w_uniform)
					H.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/toggle/labcoat(H), slot_wear_suit)
				if ("Research Assistant")
					H.equip_to_slot_or_del(new /obj/item/clothing/under/purple(H), slot_w_uniform)
					H.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/toggle/labcoat(H), slot_wear_suit)
		return ..()

/datum/job/assistant/get_access()
	return list(access_maint_tunnels)
