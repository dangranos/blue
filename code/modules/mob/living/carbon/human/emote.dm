/mob/living/carbon/human/emote(var/act,var/m_type=1,var/message = null)
	var/param = null
	var/russified = client && (client.prefs.toggles & RUS_AUTOEMOTES)

	if (findtext(act, "-", 1, null))
		var/t1 = findtext(act, "-", 1, null)
		param = copytext(act, t1 + 1, length(act) + 1)
		act = copytext(act, 1, t1)

	if(findtext(act,"s",-1) && !findtext(act,"_",-2))//Removes ending s's unless they are prefixed with a '_'
		act = copytext(act,1,length(act))

	var/muzzled = istype(src.wear_mask, /obj/item/clothing/mask/muzzle)
	//var/m_type = 1

	for (var/obj/item/weapon/implant/I in src)
		if (I.implanted)
			I.trigger(act, src)

	if(src.stat == 2.0 && (act != "deathgasp"))
		return
	switch(act)
		if ("airguitar")
			if (!src.restrained())
				if(russified)
					message = "<B>[src]</B> играет на воображаемой гитаре и тр&#255;сёт головой в такт."
				else
					message = "<B>[src]</B> is strumming the air and headbanging like a safari chimp."
				m_type = 1

		if ("blink")
			if(russified)
				message = "<B>[src]</B> моргает."
			else
				message = "<B>[src]</B> blinks."
			m_type = 1

		if ("blink_r")
			if(russified)
				message = "<B>[src]</B> часто моргает."
			else
				message = "<B>[src]</B> blinks rapidly."
			m_type = 1

		if ("bow")
			if (!src.buckled)
				var/M = null
				if (param)
					for (var/mob/A in view(null, null))
						if (param == A.name)
							M = A
							break
				if (!M)
					param = null

				if (param)
					if(russified)
						message = "<B>[src]</B> клан&#255;етс&#255; [param]."
					else
						message = "<B>[src]</B> bows to [param]."
				else
					if(russified)
						message = "<B>[src]</B> клан&#255;етс&#255;."
					else
						message = "<B>[src]</B> bows."
			m_type = 1

		if ("custom")
			var/input = sanitize(input("Choose an emote to display.") as text|null)
			if (!input)
				return
			var/input2 = input("Is this a visible or hearable emote?") in list("Visible","Hearable")
			if (input2 == "Visible")
				m_type = 1
			else if (input2 == "Hearable")
				if (src.miming)
					return
				m_type = 2
			else
				alert("Unable to use this emote, must be either hearable or visible.")
				return
			return custom_emote(m_type, message)

		if ("me")

			//if(silent && silent > 0 && findtext(message,"\"",1, null) > 0)
			//	return //This check does not work and I have no idea why, I'm leaving it in for reference.

			if (src.client)
				if (client.prefs.muted & MUTE_IC)
					src << "\red You cannot send IC messages (muted)."
					return
				if (src.client.handle_spam_prevention(message,MUTE_IC))
					return
			if (stat)
				return
			if(!(message))
				return
			return custom_emote(m_type, message)

		if ("salute")
			if (!src.buckled)
				var/M = null
				if (param)
					for (var/mob/A in view(null, null))
						if (param == A.name)
							M = A
							break
				if (!M)
					param = null

				if (param)
					if(russified)
						message = "<B>[src]</B> отдает честь [param]."
					else
						message = "<B>[src]</B> salutes to [param]."
				else
					if(russified)
						message = "<B>[src]</b> отдает честь."
					else
						message = "<B>[src]</b> salutes."
			m_type = 1

		if ("choke")
			if(miming)
				if(russified)
					message = "<B>[src]</B> хватаетс&#255; за горло!"
				else
					message = "<B>[src]</B> clutches \his throat desperately!"
				m_type = 1
			else
				if (!muzzled)
					if(russified)
						message = "<B>[src]</B> задыхаетс&#255;!"
					else
						message = "<B>[src]</B> chokes!"
					m_type = 2
				else
					if(russified)
						message = "<B>[src]</B> издаёт громкий звук."
					else
						message = "<B>[src]</B> makes a strong noise."
					m_type = 2

		if ("clap")
			if (!src.restrained())
				if(russified)
					message = "<B>[src]</B> хлопает в ладоши."
				else
					message = "<B>[src]</B> claps."
				m_type = 2
				if(miming)
					m_type = 1
		if ("flap")
			if (!src.restrained())
				if(russified)
					message = "<B>[src]</B> хлопает своими крыль&#255;ми."
				else
					message = "<B>[src]</B> flaps \his wings."
				m_type = 2
				if(miming)
					m_type = 1

		if ("aflap")
			if (!src.restrained())
				if(russified)
					message = "<B>[src]</B> угражающе хлопает крыль&#255;ми!"
				else
					message = "<B>[src]</B> flaps \his wings ANGRILY!"
				m_type = 2
				if(miming)
					m_type = 1

		if ("drool")
			if(russified)
				message = "<B>[src]</B> пускает слюни."
			else
				message = "<B>[src]</B> drools."
			m_type = 1

		if ("eyebrow")
			if(russified)
				message = "<B>[src]</B> вопросительно поднимает бровь."
			else
				message = "<B>[src]</B> raises an eyebrow."
			m_type = 1

		if ("chuckle")
			if(miming)
				if(russified)
					message = "<B>[src]</B> беззвучно хихикает."
				else
					message = "<B>[src]</B> appears to chuckle."
				m_type = 1
			else
				if (!muzzled)
					if(russified)
						message = "<B>[src]</B> посмеиваетс&#255;."
					else
						message = "<B>[src]</B> chuckles."
					m_type = 2
				else
					message = "<B>[src]</B> makes a noise."
					m_type = 2

		if ("twitch")
			if(russified)
				message = "<B>[src]</B> &#255;ростно дергаетс&#255;."
			else
				message = "<B>[src]</B> twitches violently."
			m_type = 1

		if ("twitch_s")
			if(russified)
				message = "<B>[src]</B> дергаетс&#255;."
			else
				message = "<B>[src]</B> twitches."
			m_type = 1

		if ("faint")
			if(russified)
				message = "<B>[src]</B> падает в обморок."
			else
				message = "<B>[src]</B> faints."
			if(src.sleeping)
				return //Can't faint while asleep
			src.sleeping += 10 //Short-short nap
			m_type = 1

		if ("cough")
			if(miming)
				if(russified)
					message = "<B>[src]</B> беззвучно кашл&#255;ет!"
				else
					message = "<B>[src]</B> appears to cough!"
				m_type = 1
			else
				if (!muzzled)
					if(russified)
						message = "<B>[src]</B> кашл&#255;ет!"
					else
						message = "<B>[src]</B> coughs!"
					m_type = 2
				else
					if(russified)
						message = "<B>[src]</B> издает громкий звук."
					else
						message = "<B>[src]</B> makes a strong noise."
					m_type = 2

		if ("frown")
			if(russified)
				if(gender == FEMALE)
					message = "<B>[src]</B> нахмурилась."
				else
					message = "<B>[src]</B> нахмурилс&#255;."
			else
				message = "<B>[src]</B> frowns."
			m_type = 1

		if ("nod")
			if(russified)
				message = "<B>[src]</B> кивает."
			else
				message = "<B>[src]</B> nods."
			m_type = 1

		if ("blush")
			if(russified)
				message = "<B>[src]</B> краснеет."
			else
				message = "<B>[src]</B> blushes."
			m_type = 1

		if ("wave")
			if(russified)
				message = "<B>[src]</B> машет рукой."
			else
				message = "<B>[src]</B> waves."
			m_type = 1

		if ("gasp")
			if(miming)
				if(russified)
					message = "<B>[src]</B> беззвучно задыхаетс&#255;!"
				else
					message = "<B>[src]</B> appears to be gasping!"
				m_type = 1
			else
				if (!muzzled)
					if(russified)
						message = "<B>[src]</B> рефлекторно пытаетс&#255; вдохнуть!"
					else
						message = "<B>[src]</B> gasps!"
					m_type = 2
				else
					if(russified)
						message = "<B>[src]</B> издаёт слабый звук."
					else
						message = "<B>[src]</B> makes a weak noise."
					m_type = 2

		if ("deathgasp")
			message = "<B>[src]</B> [species.death_message]"
			m_type = 1

		if ("giggle")
			if(miming)
				if(russified)
					message = "<B>[src]</B> тихо хихикает!"
				else
					message = "<B>[src]</B> giggles silently!"
				m_type = 1
			else
				if (!muzzled)
					if(russified)
						message = "<B>[src]</B> хихикает."
					else
						message = "<B>[src]</B> giggles."
					m_type = 2
				else
					if(russified)
						message = "<B>[src]</B> издаёт тихий звук."
					else
						message = "<B>[src]</B> makes a noise."
					m_type = 2

		if ("glare")
			var/M = null
			if (param)
				for (var/mob/A in view(null, null))
					if (param == A.name)
						M = A
						break
			if (!M)
				param = null

			if (param)
				if(russified)
					message = "<B>[src]</B> смотрит на [param] со злобой."
				else
					message = "<B>[src]</B> glares at [param]."
			else
				if(russified)
					message = "<B>[src]</B> злобно смотрит."
				else
					message = "<B>[src]</B> glares."

		if ("stare")
			var/M = null
			if (param)
				for (var/mob/A in view(null, null))
					if (param == A.name)
						M = A
						break
			if (!M)
				param = null

			if (param)
				if(russified)
					message = "<B>[src]</B> п&#255;литс&#255; на [param]."
				else
					message = "<B>[src]</B> stares at [param]."
			else
				if(russified)
					message = "<B>[src]</B> внимательно смотрит на происход&#255;щее."
				else
					message = "<B>[src]</B> stares."

		if ("look")
			var/M = null
			if (param)
				for (var/mob/A in view(null, null))
					if (param == A.name)
						M = A
						break

			if (!M)
				param = null

			if (param)
				if(russified)
					message = "<B>[src]</B> смотрит на [param]."
				else
					message = "<B>[src]</B> looks at [param]."
			else
				if(russified)
					message = "<B>[src]</B> осматриваетс&#255;."
				else
					message = "<B>[src]</B> looks."
			m_type = 1

		if ("grin")
			if(russified)
				message = "<B>[src]</B> ухмыл&#255;етс&#255;."
			else
				message = "<B>[src]</B> grins."
			m_type = 1

		if ("cry")
			if(miming)
				if(russified)
					message = "<B>[src]</B> плачет."
				else
					message = "<B>[src]</B> cries."
				m_type = 1
			else
				if (!muzzled)
					if(russified)
						message = "<B>[src]</B> плачет."
					else
						message = "<B>[src]</B> cries."
					m_type = 2
				else
					if(russified)
						message = "<B>[src]</B>, зажмурившись, издает тихий звук."
					else
						message = "<B>[src]</B> makes a weak noise. \He frowns."
					m_type = 2

		if ("sigh")
			if(miming)
				if(russified)
					message = "<B>[src]</B> вздыхает."
				else
					message = "<B>[src]</B> sighs."
				m_type = 1
			else
				if (!muzzled)
					if(russified)
						message = "<B>[src]</B> вздыхает."
					else
						message = "<B>[src]</B> sighs."
					m_type = 2
				else
					if(russified)
						message = "<B>[src]</B> издаёт тихий звук."
					else
						message = "<B>[src]</B> makes a weak noise."
					m_type = 2

		if ("laugh")
			if(miming)
				if(russified)
					message = "<B>[src]</B> беззвучно хохочет."
				else
					message = "<B>[src]</B> acts out a laugh."
				m_type = 1
			else
				if (!muzzled)
					if(russified)
						message = "<B>[src]</B> смеётс&#255;."
					else
						message = "<B>[src]</B> laughs."
					m_type = 2
				else
					if(russified)
						message = "<B>[src]</B> издает звук."
					else
						message = "<B>[src]</B> makes a noise."
					m_type = 2

		if ("mumble")
			if(russified)
				message = "<B>[src]</B> бормочет что-то невн&#255;тное."
			else
				message = "<B>[src]</B> mumbles!"
			m_type = 2
			if(miming)
				m_type = 1

		if ("grumble")
			if(miming)
				if(russified)
					message = "<B>[src]</B> изображает дурное настроение!"
				else
					message = "<B>[src]</B> grumbles!"
				m_type = 1
			if (!muzzled)
				if(russified)
					message = "<B>[src]</B> ворчит!"
				else
					message = "<B>[src]</B> grumbles!"
				m_type = 2
			else
				if(russified)
					message = "<B>[src]</B> издает тихий звук."
				else
					message = "<B>[src]</B> makes a noise."
				m_type = 2

		if ("groan")
			if(miming)
				if(russified)
					message = "<B>[src]</B> изображает усталость."
				else
					message = "<B>[src]</B> appears to groan!"
				m_type = 1
			else
				if (!muzzled)
					if(russified)
						message = "<B>[src]</B> устало стонет."
					else
						message = "<B>[src]</B> groans!"
					m_type = 2
				else
					if(russified)
						message = "<B>[src]</B> издает долгий, т&#255;нущийс&#255; звук."
					else
						message = "<B>[src]</B> makes a loud noise."
					m_type = 2

		if ("moan")
			if(miming)
				if(russified)
					message = "<B>[src]</B> качает головой!"
				else
					message = "<B>[src]</B> appears to moan!"
				m_type = 1
			else
				if(russified)
					message = "<B>[src]</B> стонет!"
				else
					message = "<B>[src]</B> moans!"
				m_type = 2

		if ("johnny")
			if (param && gender!=FEMALE)
				if(miming)
					if(russified)
						message = "<B>[src]</B> зат&#255;нулс&#255; сигаретой и написал \"[param]\" выдыхаемым дымом."
					else
						message = "<B>[src]</B> takes a drag from a cigarette and blows \"[param]\" out in smoke."
					m_type = 1
				else
					if(russified)
						message = "<B>[src]</B> says, \"[param], боже. У него была семь&#255;.\" [src.name] делает зат&#255;жку и рисует своё им&#255; в облаке дыма."
					else
						message = "<B>[src]</B> says, \"[param], please. He had a family.\" [src.name] takes a drag from a cigarette and blows their name out in smoke."
					m_type = 2

		if ("point")
			if (!src.restrained())
				var/mob/M = null
				if (param)
					for (var/atom/A as mob|obj|turf|area in view(null, null))
						if (param == A.name)
							M = A
							break

				if (!M)
					if(russified)
						message = "<B>[src]</B> показывает куда-то."
					else
						message = "<B>[src]</B> points."
				else
					pointed(M)

				if (M)
					if(russified)
						message = "<B>[src]</B> указывает на [M]."
					else
						message = "<B>[src]</B> points to [M]."
				else
			m_type = 1

		if ("raise")
			if (!src.restrained())
				if(russified)
					message = "<B>[src]</B> поднимает руку вверх."
				else
					message = "<B>[src]</B> raises a hand."
			m_type = 1

		if("shake")
			if(russified)
				message = "<B>[src]</B> тр&#255;сёт головой."
			else
				message = "<B>[src]</B> shakes \his head."
			m_type = 1

		if ("shrug")
			if(russified)
				message = "<B>[src]</B> пожимает плечами."
			else
				message = "<B>[src]</B> shrugs."
			m_type = 1

		if ("signal")
			if (!src.restrained())
				var/t1 = round(text2num(param))
				if (isnum(t1))
					if (t1 <= 5)
						if((src.r_hand || !get_organ("r_hand")) && (src.l_hand  || !get_organ("l_hand")))
							usr << "<span class='warning'>Your need at least one free hand for this</span>"
							return
						if(!russified)
							message = "<B>[src]</B> raises [t1] finger\s."
						else
							switch(t1)
								if(1)   message = "<B>[src]</B> поднимает [t1] палец."
								if(2-4) message = "<B>[src]</B> поднимает [t1] палеца."
								if(5)   message = "<B>[src]</B> поднимает [t1] пальцев."
					else if (t1 <= 10)
						if((src.r_hand || !get_organ("r_hand")) || (src.l_hand  || !get_organ("l_hand")))
							usr << "<span class='warning'>Your need at least two free hands for this</span>"
							return
						if(russified)
							message = "<B>[src]</B> поднимает [t1] пальцев."
						else
							message = "<B>[src]</B> raises [t1] finger\s."
			m_type = 1

		if ("smile")
			if(russified)
				message = "<B>[src]</B> улыбаетс&#255;."
			else
				message = "<B>[src]</B> smiles."
			m_type = 1

		if ("shiver")
			if(russified)
				message = "<B>[src]</B> дрожит."
			else
				message = "<B>[src]</B> shivers."
			m_type = 2
			if(miming)
				m_type = 1

		if ("pale")
			if(russified)
				message = "<B>[src]</B> бледнеет."
			else
				message = "<B>[src]</B> goes pale for a second."
			m_type = 1

		if ("tremble")
			if(russified)
				message = "<B>[src]</B> дрожит от страха!"
			else
				message = "<B>[src]</B> trembles in fear!"
			m_type = 1

		if ("sneeze")
			if (miming)
				if(russified)
					message = "<B>[src]</B> чихает."
				else
					message = "<B>[src]</B> sneezes."
				m_type = 1
			else
				if (!muzzled)
					if(russified)
						message = "<B>[src]</B> чихает."
					else
						message = "<B>[src]</B> sneezes."
					m_type = 2
				else
					if(russified)
						message = "<B>[src]</B> издаёт странный звук."
					else
						message = "<B>[src]</B> makes a strange noise."
					m_type = 2

		if ("sniff")
			if(russified)
				message = "<B>[src]</B> шмыгает носом."
			else
				message = "<B>[src]</B> sniffs."
			m_type = 2
			if(miming)
				m_type = 1

		if ("snore")
			if (miming)
				if(russified)
					message = "<B>[src]</B> громко храпит."
				else
					message = "<B>[src]</B> sleeps soundly."
				m_type = 1
			else
				if (!muzzled)
					if(russified)
						message = "<B>[src]</B> храпит."
					else
						message = "<B>[src]</B> snores."
					m_type = 2
				else
					if(russified)
						message = "<B>[src]</B> сопит."
					else
						message = "<B>[src]</B> makes a quiet noise."
					m_type = 2

		if ("whimper")
			if (miming)
				if(russified)
					message = "<B>[src]</B> выгл&#255;дит у&#255;звленно."
				else
					message = "<B>[src]</B> appears hurt."
				m_type = 1
			else
				if (!muzzled)
					if(russified)
						message = "<B>[src]</B> всхлипывает."
					else
						message = "<B>[src]</B> whimpers."
					m_type = 2
				else
					if(russified)
						message = "<B>[src]</B> шмыгает носом."
					else
						message = "<B>[src]</B> makes a weak noise."
					m_type = 2

		if ("wink")
			if(russified)
				message = "<B>[src]</B> подмигивает."
			else
				message = "<B>[src]</B> winks."
			m_type = 1

		if ("yawn")
			if (!muzzled)
				if(russified)
					message = "<B>[src]</B> зевает."
				else
					message = "<B>[src]</B> yawns."
				m_type = 2
				if(miming)
					m_type = 1

		if ("collapse")
			Paralyse(2)
			if(russified)
				message = "<B>[src]</B> тер&#255;ет сознание!"
			else
				message = "<B>[src]</B> collapses!"
			m_type = 2
			if(miming)
				m_type = 1

		if("hug")
			m_type = 1
			if (!src.restrained())
				var/M = null
				if (param)
					for (var/mob/A in view(1, null))
						if (param == A.name)
							M = A
							break
				if (M == src)
					M = null

				if (M)
					if(russified)
						message = "<B>[src]</B> обнимает [M]."
					else
						message = "<B>[src]</B> hugs [M]."
				else
					if(russified)
						message = "<B>[src]</B> обнимает себ&#255;."
					else
						message = "<B>[src]</B> hugs \himself."

		if ("handshake")
			m_type = 1
			if (!src.restrained() && !src.r_hand)
				var/mob/M = null
				if (param)
					for (var/mob/A in view(1, null))
						if (param == A.name)
							M = A
							break
				if (M == src)
					M = null

				if (M)
					if (M.canmove && !M.r_hand && !M.restrained())
						if(russified)
							message = "<B>[src]</B> жмет руки с [M]."
						else
							message = "<B>[src]</B> shakes hands with [M]."
					else
						if(russified)
							message = "<B>[src]</B> прот&#255;гивает руку [M]."
						else
							message = "<B>[src]</B> holds out \his hand to [M]."

		if("dap")
			m_type = 1
			if (!src.restrained())
				var/M = null
				if (param)
					for (var/mob/A in view(1, null))
						if (param == A.name)
							M = A
							break
				if (M)
					if(russified)
						message = "<B>[src]</B> делает брофист с [M]."
					else
						message = "<B>[src]</B> gives daps to [M]."
				else
					if(russified)
						message = "<B>[src]</B> не найд&#255; никого р&#255;дом с собой, делает  брофист сам с собой.  Жалкое зрелище"
					else
						message = "<B>[src]</B> sadly can't find anybody to give daps to, and daps \himself. Shameful."

		if ("scream")
			if (miming)
				if(russified)
					message = "<B>[src]</B> изображает крик!"
				else
					message = "<B>[src]</B> acts out a scream!"
				m_type = 1
			else
				if (!muzzled)
					if(russified)
						message = "<B>[src]</B> кричит!"
					else
						message = "<B>[src]</B> screams!"
					m_type = 2
				else
					if(russified)
						message = "<B>[src]</B> издаёт очень громкий звук."
					else
						message = "<B>[src]</B> makes a very loud noise."
					m_type = 2

		if("kiss")
			m_type = 1
			if (!src.restrained())
				var/M = null
				if (param)
					for (var/mob/A in view(1, null))
						if (param == A.name)
							M = A
							break
				if (M == src)
					M = null

				if (M)
					if(russified)
						message = "<B>[src]</B> целует [M]."

						message = "<B>[src]</B> kisses [M]."

		if("cuddle")
			m_type = 1
			if (!src.restrained())
				var/M = null
				if (param)
					for (var/mob/A in view(1, null))
						if (param == A.name)
							M = A
							break
				if (M == src)
					M = null

				if (M)
					if(russified)
						message = "<B>[src]</B> прижимаетс&#255; к [M]."

						message = "<B>[src]</B> cuddles [M]."

		if("snuggle")
			m_type = 1
			if (!src.restrained())
				var/M = null
				if (param)
					for (var/mob/A in view(1, null))
						if (param == A.name)
							M = A
							break
				if (M == src)
					M = null

				if (M)
					if(russified)
						message = "<B>[src]</B> прижимает [M] к себе."

						message = "<B>[src]</B> snuggles [M]."

		if ("hum")
			if (miming)
				if(russified)
					message = "<B>[src]</B> покачивает головой."
				else
					message = "<B>[src]</B> shakes /his head."
				m_type = 1
			else
				if (!muzzled)
					if(russified)
						message = "<B>[src]</B> напевает себе под нос."
					else
						message = "<B>[src]</B> hums."
					m_type = 2
				else
					if(russified)
						message = "<B>[src]</B> издаёт слабый звук."
					else
						message = "<B>[src]</B> makes a weak noise."
					m_type = 2

		if ("whistle")
			if (miming)
				if(russified)
					message = "<B>[src]</B> имитирует свист!"
				else
					message = "<B>[src]</B> appears to whistle."
				m_type = 1
			else
				if (!muzzled)
					if(russified)
						message = "<B>[src]</B> свистит!"
					else
						message = "<B>[src]</B> whistles!"
					m_type = 2
				else
					if(russified)
						message = "<B>[src]</B> издаёт слабый звук."
					else
						message = "<B>[src]</B> makes a weak noise."
					m_type = 2

		if ("clear")
			if (miming)
				if(russified)
					message = "<B>[src]</B> беззвучно кашл&#255;ет."
				else
					message = "<B>[src]</B> appears to cough."
				m_type = 1
			else
				if (!muzzled)
					if(russified)
						message = "<B>[src]</B> прочищает горло."
					else
						message = "<B>[src]</B> clears /his throat"
					m_type = 2
				else
					if(russified)
						message = "<B>[src]</B> издаёт слабый звук."
					else
						message = "<B>[src]</B> makes a weak noise."
					m_type = 2

		if ("hem")
			if (miming)
				if(russified)
					message = "<B>[src]</B> выгл&#255;дит неуверенно."
				else
					message = "<B>[src]</B> seems unsure."
				m_type = 1
			else
				if (!muzzled)
					if(russified)
						message = "<B>[src]</B> хмыкает."
					else
						message = "<B>[src]</B> hems"
					m_type = 2
				else
					if(russified)
						message = "<B>[src]</B> издаёт сомневающийс&#255; звук."
					else
						message = "<B>[src]</B> makes an unsure noise."
					m_type = 2

		if("swish")
			src.animate_tail_once()

		if("wag", "sway")
			src.animate_tail_start()

		if("qwag", "fastsway")
			src.animate_tail_fast()

		if("swag", "stopsway")
			src.animate_tail_stop()

		if ("help")
			src << {"blink, blink_r, blush, bow-(none)/mob, burp, choke, chuckle, clap, collapse, cough,
cry, custom, deathgasp, drool, eyebrow, frown, gasp, giggle, groan, grumble, handshake, hug-(none)/mob, glare-(none)/mob,
grin, laugh, look-(none)/mob, moan, mumble, nod, pale, point-atom, raise, salute, shake, shiver, shrug,
sigh, signal-#1-10, smile, sneeze, sniff, snore, stare-(none)/mob, tremble, twitch, twitch_s, whimper,
wink, yawn, swish, sway/wag, fastsway/qwag, stopsway/swag"}

		else
			src << "\blue Unusable emote '[act]'. Say *help for a list."





	if (message)
		log_emote("[name]/[key] : [message]")

 //Hearing gasp and such every five seconds is not good emotes were not global for a reason.
 // Maybe some people are okay with that.

		for(var/mob/M in dead_mob_list)
			if(!M.client || istype(M, /mob/new_player))
				continue //skip monkeys, leavers and new players
			if(M.stat == DEAD && (M.client.prefs.chat_toggles & CHAT_GHOSTSIGHT) && !(M in viewers(src,null)))
				M.show_message(message)


		if (m_type & 1)
			for (var/mob/O in get_mobs_in_view(world.view,src))
				O.show_message(message, m_type)
		else if (m_type & 2)
			for (var/mob/O in (hearers(src.loc, null) | get_mobs_in_view(world.view,src)))
				O.show_message(message, m_type)


/mob/living/carbon/human/verb/pose()
	set name = "Set Pose"
	set desc = "Sets a description which will be shown when someone examines you."
	set category = "IC"

	pose =  sanitize(input(usr, "This is [src]. \He is...", "Pose", null)  as text)

/mob/living/carbon/human/verb/set_flavor()
	set name = "Set Flavour Text"
	set desc = "Sets an extended description of your character's features."
	set category = "IC"

	var/HTML = "<body>"
	HTML += "<tt><center>"
	HTML += "<b>Update Flavour Text</b> <hr />"
	HTML += "<br></center>"
	for( var/flavor in flavs_list )
		HTML += "<a href='byond://?src=\ref[src];flavor_change=[flavor]'>[flavs_list[flavor]]</a>: [TextPreview(flavor_texts[flavor])]<br>"
	HTML += "<br>"
	HTML += "<hr />"
	HTML +="<a href='?src=\ref[src];flavor_change=done'>\[Done\]</a>"
	HTML += "<tt>"
	src << browse(HTML, "window=flavor_changes;size=430x300")
