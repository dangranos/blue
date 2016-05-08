/obj/item/clothing/suit/storage/toggle/labcoat
	name = "labcoat"
	desc = "A suit that protects against minor chemical spills."
	icon_state = "labcoat_open"
	item_state = "labcoat" //Is this even used for anything?
	icon_open = "labcoat_open"
	icon_closed = "labcoat"
	blood_overlay_type = "coat"
	body_parts_covered = UPPER_TORSO|ARMS
	allowed = list(/obj/item/device/analyzer,/obj/item/stack/medical,/obj/item/weapon/dnainjector,\
			/obj/item/weapon/reagent_containers/dropper,/obj/item/weapon/reagent_containers/syringe,\
			/obj/item/weapon/reagent_containers/hypospray,/obj/item/device/healthanalyzer,\
			/obj/item/device/flashlight/pen,/obj/item/weapon/reagent_containers/glass/beaker/bottle,\
			/obj/item/weapon/reagent_containers/glass/beaker,/obj/item/weapon/reagent_containers/pill,\
			/obj/item/weapon/storage/pill_bottle,/obj/item/weapon/paper,/obj/item/device/radio)
	armor = list(melee = 0, bullet = 0, laser = 0,energy = 0, bomb = 0, bio = 50, rad = 0)

/obj/item/clothing/suit/storage/toggle/labcoat/red
	name = "red labcoat"
	desc = "A suit that protects against minor chemical spills. This one is red."
	icon_state = "red_labcoat_open"
	item_state = "red_labcoat"
	icon_open = "red_labcoat_open"
	icon_closed = "red_labcoat"

/obj/item/clothing/suit/storage/toggle/labcoat/blue
	name = "blue labcoat"
	desc = "A suit that protects against minor chemical spills. This one is blue."
	icon_state = "blue_labcoat_open"
	item_state = "blue_labcoat"
	icon_open = "blue_labcoat_open"
	icon_closed = "blue_labcoat"

/obj/item/clothing/suit/storage/toggle/labcoat/purple
	name = "purple labcoat"
	desc = "A suit that protects against minor chemical spills. This one is purple."
	icon_state = "purple_labcoat_open"
	item_state = "purple_labcoat"
	icon_open = "purple_labcoat_open"
	icon_closed = "purple_labcoat"

/obj/item/clothing/suit/storage/toggle/labcoat/orange
	name = "orange labcoat"
	desc = "A suit that protects against minor chemical spills. This one is orange."
	icon_state = "orange_labcoat_open"
	item_state = "orange_labcoat"
	icon_open = "orange_labcoat_open"
	icon_closed = "orange_labcoat"

/obj/item/clothing/suit/storage/toggle/labcoat/green
	name = "green labcoat"
	desc = "A suit that protects against minor chemical spills. This one is green."
	icon_state = "green_labcoat_open"
	item_state = "green_labcoat"
	icon_open = "green_labcoat_open"
	icon_closed = "green_labcoat"

/obj/item/clothing/suit/storage/toggle/labcoat/cmo
	name = "chief medical officer's labcoat"
	desc = "Bluer than the standard model."
	icon_state = "labcoat_cmo_open"
	item_state = "labcoat_cmo"
	icon_open = "labcoat_cmo_open"
	icon_closed = "labcoat_cmo"

/obj/item/clothing/suit/storage/toggle/labcoat/cmoalt
	name = "chief medical officer labcoat"
	desc = "A labcoat with command blue highlights."
	icon_state = "labcoat_cmoalt_open"
	icon_open = "labcoat_cmoalt_open"
	icon_closed = "labcoat_cmoalt"

/obj/item/clothing/suit/storage/toggle/labcoat/mad
	name = "The Mad's labcoat"
	desc = "It makes you look capable of konking someone on the noggin and shooting them into space."
	icon_state = "labgreen_open"
	item_state = "labgreen"
	icon_open = "labgreen_open"
	icon_closed = "labgreen"

/obj/item/clothing/suit/storage/toggle/labcoat/genetics
	name = "Geneticist labcoat"
	desc = "A suit that protects against minor chemical spills. Has a blue stripe on the shoulder."
	icon_state = "labcoat_gen_open"
	icon_open = "labcoat_gen_open"
	icon_closed = "labcoat_gen"

/obj/item/clothing/suit/storage/toggle/labcoat/chemist
	name = "Chemist labcoat"
	desc = "A suit that protects against minor chemical spills. Has an orange stripe on the shoulder."
	icon_state = "labcoat_chem_open"
	icon_open = "labcoat_chem_open"
	icon_closed = "labcoat_chem"

/obj/item/clothing/suit/storage/toggle/labcoat/forensic
	name = "Forensic Technician labcoat"
	desc = "A padded suit that protects against minor damage. Has a red stripe on the shoulder."
	icon_state = "labcoat_foren_open"
	icon_open = "labcoat_foren_open"
	icon_closed = "labcoat_foren"
	armor = list(melee = 10, bullet = 10, laser = 15, energy = 10, bomb = 0, bio = 0, rad = 0)
	allowed = list(/obj/item/device/analyzer,/obj/item/stack/medical,/obj/item/weapon/dnainjector,\
			/obj/item/weapon/reagent_containers/dropper,/obj/item/weapon/reagent_containers/syringe,\
			/obj/item/weapon/reagent_containers/hypospray,/obj/item/device/healthanalyzer,\
			/obj/item/device/flashlight/pen,/obj/item/weapon/reagent_containers/glass/beaker/bottle,\
			/obj/item/weapon/reagent_containers/glass/beaker,/obj/item/weapon/reagent_containers/pill,\
			/obj/item/weapon/storage/pill_bottle,/obj/item/weapon/reagent_containers/spray/pepper,\
			/obj/item/weapon/gun/projectile,/obj/item/ammo_magazine,/obj/item/device/detective_scanner,\
			/obj/item/device/taperecorder)

/obj/item/clothing/suit/storage/toggle/labcoat/virologist
	name = "Virologist labcoat"
	desc = "A suit that protects against minor chemical spills. Offers slightly more protection against biohazards than the standard model. Has a green stripe on the shoulder."
	icon_state = "labcoat_vir_open"
	icon_open = "labcoat_vir_open"
	icon_closed = "labcoat_vir"
	armor = list(melee = 0, bullet = 0, laser = 0,energy = 0, bomb = 0, bio = 60, rad = 0)

/obj/item/clothing/suit/storage/toggle/labcoat/science
	name = "Scientist labcoat"
	desc = "A suit that protects against minor chemical spills. Has a purple stripe on the shoulder."
	icon_state = "labcoat_tox_open"
	icon_open = "labcoat_tox_open"
	icon_closed = "labcoat_tox"

/obj/item/clothing/suit/storage/labcoat
	item_state = "labcoat"
	blood_overlay_type = "coat"
	body_parts_covered = UPPER_TORSO|ARMS
	allowed = list(/obj/item/device/analyzer,/obj/item/stack/medical,/obj/item/weapon/dnainjector,\
			/obj/item/weapon/reagent_containers/dropper,/obj/item/weapon/reagent_containers/syringe,\
			/obj/item/weapon/reagent_containers/hypospray,/obj/item/device/healthanalyzer,\
			/obj/item/device/flashlight/pen,/obj/item/weapon/reagent_containers/glass/beaker/bottle,\
			/obj/item/weapon/reagent_containers/glass/beaker,/obj/item/weapon/reagent_containers/pill,\
			/obj/item/weapon/storage/pill_bottle,/obj/item/weapon/paper,/obj/item/device/radio)
	armor = list(melee = 0, bullet = 0, laser = 0,energy = 0, bomb = 0, bio = 50, rad = 0)

/obj/item/clothing/suit/storage/labcoat/augmented
	name = "augmented labcoat"
	desc = "What a lovely diods! Blink."
	icon_state = "labcoat_aug"

/obj/item/clothing/suit/storage/labcoat/long
	name = "long labcoat"
	desc = "A suit that protects against minor chemical spills."
	icon_state = "labcoat_long"
