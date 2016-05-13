/obj/structure/trophy
	name = ""
	icon = 'icons/obj/structures.dmi'
	icon_state = "head_clown"
	desc = "Wall mounted trophy."
	var/caption = ""

	New()
		..()
		if(!name)
			var/obj/structure/trophy/new_type = pick(typesof(/obj/structure/trophy) - /obj/structure/trophy)
			name = initial(new_type.name)
			icon_state = initial(new_type.icon_state)
			caption = initial(new_type.caption)

/obj/structure/trophy/examine(mob/user)
	if(..(user, 3) && caption)
		user << "Caption: \"[caption]\""

/obj/structure/trophy/monkey
	name = "Monkey head trophy"
	icon_state = "head_monkey"
	caption = "Only few people know the true story of Mr. Dimpsi."

/obj/structure/trophy/clown
	name = "Clown head trophy"
	icon_state = "head_clown"
	caption = "King of beasts."

/obj/structure/trophy/merc
	name = "Mercenary head trophy"
	icon_state = "head_merc"
	caption = "Nobody breaks the law on my watch!"

/obj/structure/trophy/merc/black
	icon_state = "head_merc_black"

/obj/structure/trophy/alien
	name = "Alien head trophy"
	icon_state = "head_alien"
	caption = "That beast was near chop your hand off!"
