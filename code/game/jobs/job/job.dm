/datum/job

	//The name of the job
	var/title = "NONE"

	//Job access. The use of minimal_access or access is determined by a config setting: config.jobs_have_minimal_access
	var/list/minimal_access = list()		//Useful for servers which prefer to only have access given to the places a job absolutely needs (Larger server population)
	var/list/access = list()				//Useful for servers which either have fewer players, so each person needs to fill more than one role, or servers which like to give more access, so players can't hide forever in their super secure departments (I'm looking at you, chemistry!)

	//Bitflags for the job
	var/flag = 0
	var/department_flag = 0

	//Players will be allowed to spawn in as jobs that are set to "Station"
	var/faction = "None"

	//How many players can be this job
	var/total_positions = 0

	//How many players can spawn in as this job
	var/spawn_positions = 0

	//How many players have this job
	var/current_positions = 0

	//Supervisors, who this person answers to directly
	var/supervisors = ""

	//Sellection screen color
	var/selection_color = "#ffffff"

	//List of alternate titles, if any
	var/list/alt_titles

	//If this is set to 1, a text is printed to the player when jobs are assigned, telling him that he should let admins know that he has to disconnect.
	var/req_admin_notify

	//If you have use_age_restriction_for_jobs config option enabled and the database set up, this option will add a requirement for players to be at least minimal_player_age days old. (meaning they first signed in at least that many days before.)
	var/minimal_player_age = 0

	//the type of the ID the player will have
	var/idtype = /obj/item/weapon/card/id

	//job equipment
	var/implanted = 0
	var/uniform = /obj/item/clothing/under/color/grey
	var/shoes = /obj/item/clothing/shoes/black
	var/pda = /obj/item/device/pda
	var/hat = null
	var/suit = null
	var/gloves = null
	var/mask = null
	var/belt = null
	var/ear = /obj/item/device/radio/headset
	var/hand = null
	var/glasses = null

	var/list/backpacks = list(
		/obj/item/weapon/storage/backpack,\
		/obj/item/weapon/storage/backpack/satchel_norm,\
		/obj/item/weapon/storage/backpack/satchel
		)

	//This will be put in backpack. List ordered by priority!
	var/list/put_in_backpack = list(\
		/obj/item/weapon/storage/box/survival
		)

	/*For copy-pasting:
	implanted =
	uniform =
	pda =
	ear =
	shoes =
	suit =
	gloves =
	mask =
	belt =
	hand =
	glasses =
	hat =

	put_in_backpack = list(\
		/obj/item/weapon/storage/box/survival,\

		)

	backpacks = list(
		/obj/item/weapon/storage/backpack,\
		/obj/item/weapon/storage/backpack/satchel_norm,\
		/obj/item/weapon/storage/backpack/satchel
		)
	*/


/datum/job/proc/equip(var/mob/living/carbon/human/H)
	if(!H)	return 0

	//Put items in hands
	if(hand) H.equip_to_slot_or_del(new hand (H), slot_l_hand)

	//No-check items (suits, gloves, etc)
	if(ear) 	H.equip_to_slot_or_del(new ear (H), slot_l_ear)
	if(shoes)	H.equip_to_slot_or_del(new shoes (H), slot_shoes)
	if(uniform)	H.equip_to_slot_or_del(new uniform (H), slot_w_uniform)
	if(suit)	H.equip_to_slot_or_del(new suit (H), slot_wear_suit)
	if(mask)	H.equip_to_slot_or_del(new mask (H), slot_wear_mask)
	if(hat)		H.equip_to_slot_or_del(new hat (H), slot_head)
	if(gloves)	H.equip_to_slot_or_del(new gloves (H), slot_gloves)
	if(glasses)	H.equip_to_slot_or_del(new glasses (H), slot_glasses)

	//Belt and PDA
	if(belt)
		H.equip_to_slot_or_del(new belt (H), slot_belt)
		H.equip_to_slot_or_del(new pda (H), slot_l_store)
	else
		H.equip_to_slot_or_del(new pda (H), slot_belt)

	//Put items in backpack
	if(H.backbag)
		var/backpack = backpacks[H.backbag]
		H.equip_to_slot_or_del(new backpack(H), slot_back)
		for( var/obj/item/I in put_in_backpack )
			H.equip_to_slot_or_del(new I(H), slot_in_backpack)
	else
		var/list/slots = list( slot_r_store, slot_l_store, slot_r_hand, slot_l_hand, slot_s_store )
		for( var/path in put_in_backpack )
			if( !slots.len ) break
			var/obj/item/I = new path(H)
			for( var/slot in slots )
				if( H.equip_to_slot_if_possible(I, slot, 0, 1, 0) )
					slots -= slot
					break

	//Loyalty implant
	if( implanted )
		var/obj/item/weapon/implant/loyalty/L = new/obj/item/weapon/implant/loyalty(H)
		L.imp_in = H
		L.implanted = 1
		var/datum/organ/external/affected = H.get_organ("head")
		affected.implants += L
		L.part = affected

	return 1

/datum/job/proc/get_access()
	if(!config)	//Needed for robots.
		return src.minimal_access.Copy()

	if(config.jobs_have_minimal_access)
		return src.minimal_access.Copy()
	else
		return src.access.Copy()

//If the configuration option is set to require players to be logged as old enough to play certain jobs, then this proc checks that they are, otherwise it just returns 1
/datum/job/proc/player_old_enough(client/C)
	if(available_in_days(C) == 0)
		return 1	//Available in 0 days = available right now = player is old enough to play.
	return 0


/datum/job/proc/available_in_days(client/C)
	if(!C)
		return 0
	if(!config.use_age_restriction_for_jobs)
		return 0
	if(!isnum(C.player_age))
		return 0 //This is only a number if the db connection is established, otherwise it is text: "Requires database", meaning these restrictions cannot be enforced
	if(!isnum(minimal_player_age))
		return 0

	return max(0, minimal_player_age - C.player_age)

/datum/job/proc/apply_fingerprints(var/mob/living/carbon/human/H)
	if(!istype(H))
		return
	if(H.back)
		H.back.add_fingerprint(H,1)	//The 1 sets a flag to ignore gloves
		for(var/obj/item/I in H.back.contents)
			I.add_fingerprint(H,1)
	if(H.wear_id)
		H.wear_id.add_fingerprint(H,1)
	if(H.w_uniform)
		H.w_uniform.add_fingerprint(H,1)
	if(H.wear_suit)
		H.wear_suit.add_fingerprint(H,1)
	if(H.wear_mask)
		H.wear_mask.add_fingerprint(H,1)
	if(H.head)
		H.head.add_fingerprint(H,1)
	if(H.shoes)
		H.shoes.add_fingerprint(H,1)
	if(H.gloves)
		H.gloves.add_fingerprint(H,1)
	if(H.l_ear)
		H.l_ear.add_fingerprint(H,1)
	if(H.r_ear)
		H.r_ear.add_fingerprint(H,1)
	if(H.glasses)
		H.glasses.add_fingerprint(H,1)
	if(H.belt)
		H.belt.add_fingerprint(H,1)
		for(var/obj/item/I in H.belt.contents)
			I.add_fingerprint(H,1)
	if(H.s_store)
		H.s_store.add_fingerprint(H,1)
	if(H.l_store)
		H.l_store.add_fingerprint(H,1)
	if(H.r_store)
		H.r_store.add_fingerprint(H,1)
	return 1

/datum/job/proc/is_position_available()
	return (current_positions < total_positions) || (total_positions == -1)
