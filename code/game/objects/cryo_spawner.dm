/obj/cryo_spawner
	name = "cryogenic spawner"
	desc = "A man-sized pod for entering suspended animation."
	icon = 'icons/obj/Cryogenic2.dmi'
	icon_state = "body_scanner_0"
	density = 1
	anchored = 1
	var/player_spawn = 0

/obj/cryo_spawner/attack_ghost(mob/dead/observer/user as mob)
	var/mob/living/carbon/human/new_character
	if(!user) return
	var/is_admin = check_rights(show_msg = player_spawn)

	if((!is_admin && !player_spawn) || alert("Would you like to spawn?",,"Yes","No") == "No") return

	if(!is_admin)
		if(player_spawn> 0)
			player_spawn -= 1

	if(!user) return
	var/client/client = user.client

	if(client.prefs.species)
		new_character = new(loc, client.prefs.species)

	if(!new_character)
		new_character = new(loc)

	new_character.lastarea = get_area(loc)

	var/datum/language/chosen_language
	if(client.prefs.language)
		chosen_language = all_languages[client.prefs.language]
		if(chosen_language)
			new_character.add_language(client.prefs.language)

	client.prefs.copy_to(new_character)

	new_character.name = client.prefs.real_name
	new_character.dna.ready_dna(new_character)
	new_character.dna.b_type = client.prefs.b_type

	// Do the initial caching of the player's body icons.
	new_character.force_update_limbs()
	new_character.update_eyes()
	new_character.regenerate_icons()

	new_character.key = user.key

	log_admin("[key_name(new_character)] have been spawned with [name] at ([x], [y], [z])")
	equip_character(new_character, is_admin)


/obj/cryo_spawner/proc/equip_character(mob/living/carbon/human/H, is_admin=0)
	if(is_admin)
		H.equip_to_slot_or_del(new /obj/item/clothing/under/rank/centcom_captain(H), slot_w_uniform)
		H.equip_to_slot_or_del(new /obj/item/clothing/shoes/laceup(H), slot_shoes)
		H.equip_to_slot_or_del(new /obj/item/clothing/gloves/white(H), slot_gloves)
		H.equip_to_slot_or_del(new /obj/item/clothing/head/beret/centcom/captain(H), slot_head)
		H.equip_to_slot_or_del(new /obj/item/clothing/glasses/sunglasses(H), slot_l_store)
		H.equip_to_slot_or_del(new /obj/item/weapon/gun/energy(H), slot_belt)

		var/obj/item/weapon/card/id/centcom/W = new(H)
		W.name = "[H.real_name]'s ID Card"
		W.access = get_all_accesses()
		W.access += get_all_centcom_access()
		W.assignment = "NanoTrasen Navy Captain"
		W.registered_name = H.real_name
		H.equip_to_slot_or_del(W, slot_wear_id)
	else
		H.equip_to_slot_or_del(new /obj/item/clothing/under/rank/centcom_officer(H), slot_w_uniform)
		H.equip_to_slot_or_del(new /obj/item/clothing/shoes/laceup(H), slot_shoes)
		H.equip_to_slot_or_del(new /obj/item/clothing/gloves/white(H), slot_gloves)
		H.equip_to_slot_or_del(new /obj/item/clothing/head/beret/centcom/officer(H), slot_head)

		H.equip_to_slot_or_del(new /obj/item/clothing/glasses/sunglasses(H), slot_l_store)
		H.equip_to_slot_or_del(new /obj/item/weapon/gun/energy(H), slot_belt)

		var/obj/item/weapon/card/id/centcom/W = new(H)
		W.name = "[H.real_name]'s ID Card"
		W.access = get_all_accesses()
		W.access += get_all_centcom_access()
		W.assignment = "NanoTrasen Navy Officer"
		W.registered_name = H.real_name
		H.equip_to_slot_or_del(W, slot_wear_id)


/obj/cryo_spawner/thunderred
	name = "thunderdome spawner (RED)"
	player_spawn = -1

/obj/cryo_spawner/thunderred/equip_character(mob/living/carbon/human/H, is_admin)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/darkred(H), slot_w_uniform)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/jackboots(H), slot_shoes)
	H.equip_to_slot_or_del(new /obj/item/clothing/gloves/black(H), slot_gloves)
	H.equip_to_slot_or_del(new /obj/item/clothing/suit/armor/vest(H), slot_wear_suit)
	H.equip_to_slot_or_del(new /obj/item/ammo_magazine/legalist(H), slot_r_store)
	H.equip_to_slot_or_del(new /obj/item/clothing/glasses/sunglasses(H), slot_l_store)
	H.equip_to_slot_or_del(new /obj/item/weapon/gun/projectile/legalist(H), slot_belt)

	var/obj/item/weapon/card/id/centcom/W = new(H)
	W.name = "[H.real_name]'s ID Card"
	W.assignment = "Thunderdome Participant (Red Team)"
	W.registered_name = H.real_name
	H.equip_to_slot_or_del(W, slot_wear_id)


/obj/cryo_spawner/thunderblue
	name = "thunderdome spawner (BLUE)"
	icon_state = "body_scanner_0-r"
	player_spawn = -1

/obj/cryo_spawner/thunderblue/equip_character(mob/living/carbon/human/H, is_admin)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/darkblue(H), slot_w_uniform)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/jackboots(H), slot_shoes)
	H.equip_to_slot_or_del(new /obj/item/clothing/gloves/black(H), slot_gloves)
	H.equip_to_slot_or_del(new /obj/item/clothing/suit/armor/vest(H), slot_wear_suit)
	H.equip_to_slot_or_del(new /obj/item/ammo_magazine/legalist(H), slot_r_store)
	H.equip_to_slot_or_del(new /obj/item/clothing/glasses/sunglasses(H), slot_l_store)
	H.equip_to_slot_or_del(new /obj/item/weapon/gun/projectile/legalist(H), slot_belt)

	var/obj/item/weapon/card/id/centcom/W = new(H)
	W.name = "[H.real_name]'s ID Card"
	W.assignment = "Thunderdome Participant (Blue Team)"
	W.registered_name = H.real_name
	H.equip_to_slot_or_del(W, slot_wear_id)