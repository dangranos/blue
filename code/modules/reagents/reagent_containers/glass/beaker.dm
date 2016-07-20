// Beaker //

/obj/item/weapon/reagent_containers/glass/beaker
	/*Specials:
		attack_self() can open and close container
		update_icon() add filling overlay, lid.
		examinate()   give accurate info about container filling.*/
	name = "beaker"
	desc = "A beaker."
	icon = 'icons/obj/chemical.dmi'
	icon_state = "beaker"
	item_state = "beaker"
	matter = list("glass" = 500)
	var/lid_type = ""

/obj/item/weapon/reagent_containers/glass/beaker/New()
	..()
	if(!lid_type) lid_type = icon_state
	desc += " Can hold up to [volume] units."

/obj/item/weapon/reagent_containers/glass/beaker/attack_self()
	..()
	if(is_open_container())
		usr << "<span class = 'notice'>You put the lid on \the [src].</span>"
		flags ^= OPENCONTAINER
	else
		usr << "<span class = 'notice'>You take the lid off \the [src].</span>"
		flags |= OPENCONTAINER
	update_icon()

/obj/item/weapon/reagent_containers/glass/beaker/examine(var/mob/user)
	if(!..(user, 2))
		return
	if(!reagents)
		user << "<span class='notice'>\The [src] can't hold reagents anymore!</span>"
		return

	if(reagents.reagent_list.len)
		user << "<span class='notice'>It contains [reagents.total_volume] units of liquid.</span>"
	else
		user << "<span class='notice'>It is empty.</span>"

	if(!is_open_container())
		user << "<span class='notice'>Airtight lid seals it completely.</span>"

/obj/item/weapon/reagent_containers/glass/beaker/on_reagent_change()
	update_icon()

/obj/item/weapon/reagent_containers/glass/beaker/update_icon()
	overlays.Cut()

	if(reagents && reagents.total_volume)
		var/image/filling = image('icons/obj/reagentfillings.dmi', src, "[icon_state]10")

		var/percent = round((reagents.total_volume / volume) * 100)
		switch(percent)
			if(0 to 9)		filling.icon_state = "[icon_state]00"
			if(10 to 24) 	filling.icon_state = "[icon_state]10"
			if(25 to 49)	filling.icon_state = "[icon_state]25"
			if(50 to 74)	filling.icon_state = "[icon_state]50"
			if(75 to 79)	filling.icon_state = "[icon_state]75"
			if(80 to 90)	filling.icon_state = "[icon_state]80"
			if(91 to INFINITY)	filling.icon_state = "[icon_state]100"

		filling.color = reagents.get_color()
		overlays += filling

	if (!is_open_container())
		overlays += image(icon, src, "lid_[lid_type]")


//// Subtypes ////

/obj/item/weapon/reagent_containers/glass/beaker/large
	name = "large beaker"
	desc = "A large beaker."
	icon_state = "beakerlarge"
	matter = list("glass" = 5000)
	volume = 120
	amount_per_transfer_from_this = 10
	possible_transfer_amounts = list(5,10,15,25,30,60,120)
	flags = OPENCONTAINER

/obj/item/weapon/reagent_containers/glass/beaker/noreact
	name = "cryostasis beaker"
	desc = "A cryostasis beaker that allows for chemical storage without reactions."
	icon_state = "beakernoreact"
	matter = list("glass" = 500)
	volume = 60
	amount_per_transfer_from_this = 10
	flags = OPENCONTAINER | NOREACT
	isGlass = 0

/obj/item/weapon/reagent_containers/glass/beaker/bluespace
	name = "bluespace beaker"
	desc = "A bluespace beaker, powered by experimental bluespace technology."
	icon_state = "beakerbluespace"
	matter = list("glass" = 5000)
	volume = 300
	amount_per_transfer_from_this = 10
	possible_transfer_amounts = list(5,10,15,25,30,60,120,300)
	flags = OPENCONTAINER
	isGlass = 0

/obj/item/weapon/reagent_containers/glass/beaker/vial
	name = "vial"
	desc = "A small glass vial."
	icon_state = "vial"
	matter = list("glass" = 250)
	volume = 30
	amount_per_transfer_from_this = 10
	possible_transfer_amounts = list(5,10,15,25)
	flags = OPENCONTAINER

/obj/item/weapon/reagent_containers/glass/beaker/vial/small
	volume = 10
	amount_per_transfer_from_this = 10
	possible_transfer_amounts = list(5,10)

/obj/item/weapon/reagent_containers/glass/beaker/cryoxadone
	preloaded = list("cryoxadone" = 30)

/obj/item/weapon/reagent_containers/glass/beaker/sulphuric
	preloaded = list("sacid" = 60)


/obj/item/weapon/reagent_containers/glass/beaker/bucket
	desc = "It's a bucket."
	name = "bucket"
	icon = 'icons/obj/janitor.dmi'
	icon_state = "bucket"
	item_state = "bucket"
	matter = list(DEFAULT_WALL_MATERIAL = 200)
	w_class = 3.0
	amount_per_transfer_from_this = 20
	possible_transfer_amounts = list(10,20,30,60,120)
	volume = 120
	flags = OPENCONTAINER
	unacidable = 0
	isGlass = 0

/obj/item/weapon/reagent_containers/glass/beaker/bucket/attackby(var/obj/D, mob/user as mob)
	if(isprox(D))
		user << "You add [D] to [src]."
		qdel(D)
		user.put_in_hands(new /obj/item/weapon/bucket_sensor)
		user.drop_from_inventory(src)
		qdel(src)
		return
	else if(istype(D, /obj/item/weapon/mop))
		if(reagents.total_volume < 1)
			user << "<span class='warning'>\The [src] is empty!</span>"
		else
			reagents.trans_to_obj(D, 5)
			user << "<span class='notice'>You wet \the [D] in \the [src].</span>"
			playsound(loc, 'sound/effects/slosh.ogg', 25, 1)
		return
	else
		return ..()

/obj/item/weapon/reagent_containers/glass/beaker/bucket/update_icon()
	overlays.Cut()
	if (!is_open_container())
		overlays += image(icon, src, "lid_[initial(icon_state)]")


/obj/item/weapon/reagent_containers/glass/beaker/cooler_bottle
	desc = "A bottle for a water-cooler."
	name = "water-cooler bottle"
	icon = 'icons/obj/vending.dmi'
	icon_state = "water_cooler_bottle"
	matter = list("glass" = 2000)
	w_class = 3.0
	amount_per_transfer_from_this = 20
	possible_transfer_amounts = list(10,20,30,60,120)
	volume = 120
