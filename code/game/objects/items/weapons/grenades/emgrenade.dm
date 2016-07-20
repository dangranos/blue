/obj/item/weapon/grenade/empgrenade
	name = "emp grenade"
	icon_state = "emp"
	item_state = "empgrenade"
	origin_tech = list(TECH_MATERIAL = 2, TECH_MAGNET = 3)

	prime()
		..()
		if(empulse(src, 4, 10))
			qdel(src)
		return

/obj/item/weapon/grenade/empgrenade/low_yield
	name = "low yield emp grenade"
	desc = "A weaker variant of the EMP grenade"
	icon_state = "lyemp"
	item_state = "lyempgrenade"
	origin_tech = list(TECH_MATERIAL = 2, TECH_MAGNET = 3)

	prime()
		..()
		if(empulse(src, 4, 1))
			qdel(src)
		return