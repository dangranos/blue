/obj/structure/sign/trophy
	name = ""
	icon_state = "head_clown"
	desc = "Wall mounted trophy."
	var/caption = ""

	New()
		..()
		if(!name)
			var/obj/structure/sign/trophy/new_type = pick(typesof(/obj/structure/sign/trophy) - type)
			name = initial(new_type.name)
			icon_state = initial(new_type.icon_state)
			caption = initial(new_type.caption)

/obj/structure/sign/trophy/examine(mob/user)
	if(..(user, 3) && caption)
		user << "Caption: \"[caption]\""

/obj/structure/sign/trophy/monkey
	name = "Monkey head trophy"
	icon_state = "head_monkey"
	caption = "Only few people know the true story of Mr. Dimpsi."

/obj/structure/sign/trophy/clown
	name = "Clown head trophy"
	icon_state = "head_clown"
	caption = "King of beasts."

/obj/structure/sign/trophy/merc
	name = "Mercenary head trophy"
	icon_state = "head_merc"
	caption = "Nobody breaks the law on my watch!"

/obj/structure/sign/trophy/merc/black
	icon_state = "head_merc_black"

/obj/structure/sign/trophy/alien
	name = "Alien head trophy"
	icon_state = "head_alien"
	caption = "That beast was near chop your hand off!"
