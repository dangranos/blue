/datum/job/hos
	title = "Head of Security"
	flag = HOS
	head_position = 1
	department = "Security"
	department_flag = ENGSEC
	faction = "Station"
	total_positions = 1
	spawn_positions = 1
	supervisors = "the captain"
	selection_color = "#ffdddd"
	idtype = /obj/item/weapon/card/id/silver
	req_admin_notify = 1
	access = list(access_security, access_eva, access_sec_doors, access_brig, access_armory, access_court,
			            access_forensics_lockers, access_morgue, access_maint_tunnels, access_all_personal_lockers,
			            access_research, access_engine, access_mining, access_medical, access_construction, access_mailsorting,
			            access_heads, access_hos, access_RC_announce, access_keycard_auth, access_gateway, access_external_airlocks)
	minimal_access = list(access_security, access_eva, access_sec_doors, access_brig, access_armory, access_court,
			            access_forensics_lockers, access_morgue, access_maint_tunnels, access_all_personal_lockers,
			            access_research, access_engine, access_mining, access_medical, access_construction, access_mailsorting,
			            access_heads, access_hos, access_RC_announce, access_keycard_auth, access_gateway, access_external_airlocks)
	minimal_player_age = 14

	implanted = 1
	uniform = /obj/item/clothing/under/rank/head_of_security
	pda = /obj/item/device/pda/heads/hos
	ear = /obj/item/device/radio/headset/heads/hos
	shoes = /obj/item/clothing/shoes/jackboots
	gloves = /obj/item/clothing/gloves/black
	glasses = /obj/item/clothing/glasses/sunglasses/sechud

	put_in_backpack = list(\
		/obj/item/weapon/storage/box/survival,\
		/obj/item/weapon/gun/energy/gun,\
		/obj/item/weapon/handcuffs
		)

	backpacks = list(
		/obj/item/weapon/storage/backpack/security,\
		/obj/item/weapon/storage/backpack/satchel_sec,\
		/obj/item/weapon/storage/backpack/satchel
		)



/datum/job/warden
	title = "Warden"
	flag = WARDEN
	department = "Security"
	department_flag = ENGSEC
	faction = "Station"
	total_positions = 1
	spawn_positions = 1
	supervisors = "the head of security"
	selection_color = "#ffeeee"
	access = list(access_security, access_eva, access_sec_doors, access_brig, access_armory, access_court, access_maint_tunnels, access_morgue, access_external_airlocks)
	minimal_access = list(access_security, access_eva, access_sec_doors, access_brig, access_armory, access_court, access_maint_tunnels, access_external_airlocks)
	minimal_player_age = 5

	implanted = 1
	uniform = /obj/item/clothing/under/rank/warden
	pda = /obj/item/device/pda/warden
	ear = /obj/item/device/radio/headset/headset_sec
	shoes = /obj/item/clothing/shoes/jackboots
	gloves = /obj/item/clothing/gloves/black
	glasses = /obj/item/clothing/glasses/sunglasses/sechud

	put_in_backpack = list(\
		/obj/item/weapon/storage/box/survival,\
		/obj/item/device/flash,\
		/obj/item/weapon/handcuffs
		)

	backpacks = list(
		/obj/item/weapon/storage/backpack/security,\
		/obj/item/weapon/storage/backpack/satchel_sec,\
		/obj/item/weapon/storage/backpack/satchel
		)



/datum/job/detective
	title = "Detective"
	flag = DETECTIVE
	department = "Security"
	department_flag = ENGSEC
	faction = "Station"
	total_positions = 2
	spawn_positions = 2
	supervisors = "the head of security"
	selection_color = "#ffeeee"
	alt_titles = list("Forensic Technician")

	access = list(access_security, access_sec_doors, access_forensics_lockers, access_morgue, access_maint_tunnels, access_court)
	minimal_access = list(access_security, access_sec_doors, access_forensics_lockers, access_morgue, access_maint_tunnels, access_court)
	alt_titles = list("Forensic Technician")
	minimal_player_age = 3

	implanted = 1
	uniform = /obj/item/clothing/under/det
	pda = /obj/item/device/pda/detective
	ear = /obj/item/device/radio/headset/headset_sec
	shoes = /obj/item/clothing/shoes/brown
	gloves = /obj/item/clothing/gloves/black

	put_in_backpack = list(\
		/obj/item/weapon/storage/box/survival,\
		/obj/item/weapon/flame/lighter/zippo,\
		/obj/item/weapon/storage/box/evidence,\
		/obj/item/device/detective_scanner
		)


	equip(var/mob/living/carbon/human/H)
		if(!..())	return 0
		if(H.mind.role_alt_title && H.mind.role_alt_title == "Forensic Technician")
			H.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/forensics/blue(H), slot_wear_suit)
		else
			H.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/det_suit(H), slot_wear_suit)
			H.equip_to_slot_or_del(new /obj/item/clothing/head/det_hat(H), slot_head)
		return 1



/datum/job/officer
	title = "Security Officer"
	flag = OFFICER
	department = "Security"
	department_flag = ENGSEC
	faction = "Station"
	total_positions = 5
	spawn_positions = 5
	supervisors = "the head of security"
	selection_color = "#ffeeee"
	access = list(access_security, access_eva, access_sec_doors, access_brig, access_court, access_maint_tunnels, access_morgue, access_external_airlocks)
	minimal_access = list(access_security, access_eva, access_sec_doors, access_brig, access_court, access_maint_tunnels, access_external_airlocks)
	minimal_player_age = 3

	implanted = 1
	uniform = /obj/item/clothing/under/rank/security
	pda = /obj/item/device/pda/security
	ear = /obj/item/device/radio/headset/headset_sec
	shoes = /obj/item/clothing/shoes/jackboots

	put_in_backpack = list(\
		/obj/item/weapon/storage/box/survival,\
		/obj/item/weapon/handcuffs,\
		/obj/item/weapon/handcuffs,\
		/obj/item/device/flash
		)

	backpacks = list(
		/obj/item/weapon/storage/backpack/security,\
		/obj/item/weapon/storage/backpack/satchel_sec,\
		/obj/item/weapon/storage/backpack/satchel
		)