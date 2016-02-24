/obj/item/clothing/head/helmet
	name = "helmet"
	desc = "Standard defence gear. Protects the head from impacts."
	icon_state = "helmet"
	flags = HEADCOVERSEYES | THICKMATERIAL
	item_state = "helmet"
	armor = list(melee = 50, bullet = 15, laser = 50,energy = 10, bomb = 25, bio = 0, rad = 0)
	flags_inv = HIDEEARS|HIDEEYES
	cold_protection = HEAD
	min_cold_protection_temperature = HELMET_MIN_COLD_PROTECTION_TEMPERATURE
	heat_protection = HEAD
	max_heat_protection_temperature = HELMET_MAX_HEAT_PROTECTION_TEMPERATURE
	siemens_coefficient = 0.7
	w_class = 3

/obj/item/clothing/head/helmet/security
	name = "security helmet"
	desc = "Standard Security gear. Protects the head from impacts."
	var/glassesup = 0

	verb/glasses()
		set category = "Object"
		set name = "Raise glasses up/down"
		set src in usr
		if(usr.canmove && !usr.stat && !usr.restrained())
			src.glassesup = !src.glassesup
			if(src.glassesup)
				icon_state = "[icon_state]_glassesup"
				usr << "You raise your helmet glasses up."
				flags_inv = HIDEEARS
				flags = THICKMATERIAL
			else
				src.icon_state = initial(icon_state)
				usr << "You place your glasses into the normal position."
			update_clothing_icon()	//so our mob-overlays update

/obj/item/clothing/head/helmet/heavy
	name = "combat helmet"
	desc = "That's the tactical helmet with multiple attachments. Protects the head from impacts."
	icon_state = "combathelmet"
	flags = HEADCOVERSEYES | THICKMATERIAL | HEADCOVERSMOUTH
	item_state = "combathelmet"
	armor = list(melee = 60, bullet = 50, laser = 55,energy = 45, bomb = 45, bio = 0, rad = 0)
	flags_inv = HIDEMASK|HIDEEARS|HIDEEYES|HIDEFACE
	siemens_coefficient = 0.4
	light_overlay = "helmet_light"
	brightness_on = 4
	var/glassesup = 0

	verb/glasses()
		set category = "Object"
		set name = "Raise glasses up/down"
		set src in usr
		if(usr.canmove && !usr.stat && !usr.restrained())
			src.glassesup = !src.glassesup
			if(src.glassesup)
				icon_state = "[icon_state]_glassesup"
				usr << "You raise your helmet visor up."
				siemens_coefficient = 0.7
				armor = list(melee = 40, bullet = 40, laser = 40,energy = 35, bomb = 35, bio = 0, rad = 0)
				flags_inv = HIDEEARS
				flags = THICKMATERIAL
				playsound(loc, 'sound/mecha/mechmove03.ogg', 50, 1, -1)
			else
				src.icon_state = initial(icon_state)
				usr << "You place your glasses into the normal position."
				playsound(loc, 'sound/mecha/mechmove03.ogg', 50, 1, -1)
			update_clothing_icon()	//so our mob-overlays update



/obj/item/clothing/head/helmet/HoS
	name = "Head of Security Hat"
	desc = "The hat of the Head of Security. For showing the officers who's in charge."
	icon_state = "hoscap"
	flags = HEADCOVERSEYES
	armor = list(melee = 80, bullet = 60, laser = 50,energy = 10, bomb = 25, bio = 10, rad = 0)
	flags_inv = HIDEEARS
	body_parts_covered = 0
	siemens_coefficient = 0.8

/obj/item/clothing/head/helmet/HoS/dermal
	name = "Dermal Armour Patch"
	desc = "You're not quite sure how you manage to take it on and off, but it implants nicely in your head."
	icon_state = "dermal"
	item_state = "dermal"
	siemens_coefficient = 0.6

/obj/item/clothing/head/helmet/warden
	name = "warden's hat"
	desc = "It's a special helmet issued to the Warden of a securiy force. Protects the head from impacts."
	icon_state = "policehelm"
	flags_inv = 0
	body_parts_covered = 0

/obj/item/clothing/head/helmet/warden/drill
	name = "warden's drill hat"
	desc = "You've definitely have seen that hat before."
	icon_state = "wardendrill"
	flags_inv = 0
	body_parts_covered = 0

/obj/item/clothing/head/helmet/hop
	name = "crew resource's hat"
	desc = "A stylish hat that both protects you from enraged former-crewmembers and gives you a false sense of authority."
	icon_state = "hopcap"
	flags_inv = 0
	body_parts_covered = 0

/obj/item/clothing/head/helmet/formalcaptain
	name = "parade hat"
	desc = "No one in a commanding position should be without a perfect, white hat of ultimate authority."
	icon_state = "officercap"
	flags_inv = 0
	body_parts_covered = 0

/obj/item/clothing/head/helmet/riot
	name = "riot helmet"
	desc = "It's a helmet specifically designed to protect against close range attacks."
	icon_state = "riot"
	item_state = "helmet"
	flags = HEADCOVERSEYES
	armor = list(melee = 82, bullet = 15, laser = 5,energy = 5, bomb = 5, bio = 2, rad = 0)
	flags_inv = HIDEEARS
	siemens_coefficient = 0.7
	var/glassesup = 0

	verb/glasses()
		set category = "Object"
		set name = "Raise glasses up/down"
		set src in usr
		if(usr.canmove && !usr.stat && !usr.restrained())
			src.glassesup = !src.glassesup
			if(src.glassesup)
				icon_state = "[icon_state]_glassesup"
				usr << "You raise your helmet glasses up."
				flags_inv = HIDEEARS
				flags = THICKMATERIAL
			else
				src.icon_state = initial(icon_state)
				usr << "You place your glasses into the normal position."
			update_clothing_icon()	//so our mob-overlays update

/obj/item/clothing/head/helmet/swat
	name = "\improper SWAT helmet"
	desc = "They're often used by highly trained Swat Members."
	icon_state = "swat"
	flags = HEADCOVERSEYES
	item_state = "swat"
	armor = list(melee = 80, bullet = 60, laser = 50,energy = 25, bomb = 50, bio = 10, rad = 0)
	flags_inv = HIDEEARS|HIDEEYES
	cold_protection = HEAD
	min_cold_protection_temperature = SPACE_HELMET_MIN_COLD_PROTECTION_TEMPERATURE
	siemens_coefficient = 0.5

/obj/item/clothing/head/helmet/merc
	name = "combat helmet"
	desc = "That's a military-grade tan helmet. Protects the head from impacts"
	icon_state = "helmet_merc"
	flags = THICKMATERIAL
	item_state = "helmet_merc"
	armor = list(melee = 65, bullet = 45, laser = 60,energy = 10, bomb = 45, bio = 0, rad = 0)
	flags_inv = HIDEEARS


/obj/item/clothing/head/helmet/thunderdome
	name = "\improper Thunderdome helmet"
	desc = "<i>'Let the battle commence!'</i>"
	icon_state = "thunderdome"
	flags = HEADCOVERSEYES
	item_state = "thunderdome"
	armor = list(melee = 80, bullet = 60, laser = 50,energy = 10, bomb = 25, bio = 10, rad = 0)
	cold_protection = HEAD
	min_cold_protection_temperature = SPACE_HELMET_MIN_COLD_PROTECTION_TEMPERATURE
	siemens_coefficient = 1

/obj/item/clothing/head/helmet/gladiator
	name = "gladiator helmet"
	desc = "Ave, Imperator, morituri te salutant."
	icon_state = "gladiator"
	flags = HEADCOVERSEYES|HEADCOVERSMOUTH|BLOCKHAIR
	item_state = "gladiator"
	flags_inv = HIDEMASK|HIDEEARS|HIDEEYES
	siemens_coefficient = 1

/obj/item/clothing/head/helmet/tactical
	name = "tactical helmet"
	desc = "An armored helmet capable of being fitted with a multitude of attachments."
	icon_state = "swathelm"
	item_state = "helmet"
	flags = HEADCOVERSEYES

	armor = list(melee = 62, bullet = 50, laser = 50,energy = 35, bomb = 10, bio = 2, rad = 0)
	flags_inv = HIDEEARS
	siemens_coefficient = 0.7

/obj/item/clothing/head/helmet/augment
	name = "Augment Array"
	desc = "A helmet with optical and cranial augments coupled to it."
	icon_state = "v62"
	flags = HEADCOVERSEYES
	item_state = "v62"
	armor = list(melee = 80, bullet = 60, laser = 50,energy = 25, bomb = 50, bio = 10, rad = 0)
	flags_inv = HIDEEARS|HIDEEYES
	cold_protection = HEAD
	min_cold_protection_temperature = SPACE_HELMET_MIN_COLD_PROTECTION_TEMPERATURE
	siemens_coefficient = 0.5

/obj/item/clothing/head/helmet/knight
	name = "medieval helmet"
	desc = "A classic metal helmet."
	icon_state = "knight_green"
	flags = HEADCOVERSEYES
	item_state = "knight_green"
	armor = list(melee = 40, bullet = 5, laser = 2,energy = 2, bomb = 2, bio = 2, rad = 0)
	flags_inv = HIDEMASK|HIDEEARS|HIDEEYES|HIDEFACE
	siemens_coefficient = 1

/obj/item/clothing/head/helmet/knight/blue
	icon_state = "knight_blue"
	item_state = "knight_blue"

/obj/item/clothing/head/helmet/knight/yellow
	icon_state = "knight_yellow"
	item_state = "knight_yellow"

/obj/item/clothing/head/helmet/knight/red
	icon_state = "knight_red"
	item_state = "knight_red"

/obj/item/clothing/head/helmet/knight/green
 	icon_state = "knight_green"
 	item_state = "knight_green"

/obj/item/clothing/head/helmet/knight/templar
	name = "crusader helmet"
	desc = "Deus Vult."
	icon_state = "knight_templar"
	item_state = "knight_templar"

//Non-hardsuit ERT helmets.
/obj/item/clothing/head/helmet/ert
	name = "emergency response team helmet"
	desc = "An in-atmosphere helmet worn by members of the NanoTrasen Emergency Response Team. Protects the head from impacts."
	icon_state = "erthelmet_cmd"
	item_state = "syndicate-helm-green"
	armor = list(melee = 62, bullet = 50, laser = 50,energy = 35, bomb = 10, bio = 2, rad = 0)

//Commander
/obj/item/clothing/head/helmet/ert/command
	name = "emergency response team commander helmet"
	desc = "An in-atmosphere helmet worn by the commander of a NanoTrasen Emergency Response Team. Has blue highlights."

//Security
/obj/item/clothing/head/helmet/ert/security
	name = "emergency response team security helmet"
	desc = "An in-atmosphere helmet worn by security members of the NanoTrasen Emergency Response Team. Has red highlights."
	icon_state = "erthelmet_sec"

//Engineer
/obj/item/clothing/head/helmet/ert/engineer
	name = "emergency response team engineer helmet"
	desc = "An in-atmosphere helmet worn by engineering members of the NanoTrasen Emergency Response Team. Has orange highlights."
	icon_state = "erthelmet_eng"

//Medical
/obj/item/clothing/head/helmet/ert/medical
	name = "emergency response team medical helmet"
	desc = "A set of armor worn by medical members of the NanoTrasen Emergency Response Team. Has red and white highlights."
	icon_state = "erthelmet_med"