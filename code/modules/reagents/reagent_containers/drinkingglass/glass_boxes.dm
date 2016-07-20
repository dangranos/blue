/obj/item/weapon/storage/box/mixedglasses
	name = "glassware box"
	desc = "A box of assorted glassware"
	can_hold = list(/obj/item/weapon/reagent_containers/glass/drinking)
	New()
		..()
		new /obj/item/weapon/reagent_containers/glass/drinking/square(src)
		new /obj/item/weapon/reagent_containers/glass/drinking/rocks(src)
		new /obj/item/weapon/reagent_containers/glass/drinking/shake(src)
		new /obj/item/weapon/reagent_containers/glass/drinking/cocktail(src)
		new /obj/item/weapon/reagent_containers/glass/drinking/shot(src)
		new /obj/item/weapon/reagent_containers/glass/drinking/pint(src)
		new /obj/item/weapon/reagent_containers/glass/drinking/mug(src)
		new /obj/item/weapon/reagent_containers/glass/drinking/wine(src)

/obj/item/weapon/storage/box/glasses
	name = "box of glasses"
	var/glass_type = /obj/item/weapon/reagent_containers/glass/drinking
	can_hold = list(/obj/item/weapon/reagent_containers/glass/drinking)
	New()
		..()

		for(var/i = 1 to 7)
			new glass_type(src)

/obj/item/weapon/storage/box/glasses/square
	name = "box of half-pint glasses"
	glass_type = /obj/item/weapon/reagent_containers/glass/drinking/square

/obj/item/weapon/storage/box/glasses/rocks
	name = "box of rocks glasses"
	glass_type = /obj/item/weapon/reagent_containers/glass/drinking/rocks

/obj/item/weapon/storage/box/glasses/shake
	name = "box of milkshake glasses"
	glass_type = /obj/item/weapon/reagent_containers/glass/drinking/shake

/obj/item/weapon/storage/box/glasses/cocktail
	name = "box of cocktail glasses"
	glass_type = /obj/item/weapon/reagent_containers/glass/drinking/cocktail

/obj/item/weapon/storage/box/glasses/shot
	name = "box of shot glasses"
	glass_type = /obj/item/weapon/reagent_containers/glass/drinking/shot

/obj/item/weapon/storage/box/glasses/pint
	name = "box of pint glasses"
	glass_type = /obj/item/weapon/reagent_containers/glass/drinking/pint

/obj/item/weapon/storage/box/glasses/mug
	name = "box of glass mugs"
	glass_type = /obj/item/weapon/reagent_containers/glass/drinking/mug

/obj/item/weapon/storage/box/glasses/wine
	name = "box of wine glasses"
	glass_type = /obj/item/weapon/reagent_containers/glass/drinking/wine

/obj/item/weapon/storage/box/glass_extras
	name = "box of cocktail garnishings"
	var/extra_type = /obj/item/weapon/glass_extra
	can_hold = list(/obj/item/weapon/glass_extra)
	storage_slots = 14
	New()
		..()

		for(var/i = 1 to 14)
			new extra_type(src)

/obj/item/weapon/storage/box/glass_extras/straws
	name = "box of straws"
	extra_type = /obj/item/weapon/glass_extra/straw

/obj/item/weapon/storage/box/glass_extras/sticks
	name = "box of drink sticks"
	extra_type = /obj/item/weapon/glass_extra/stick
