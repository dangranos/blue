#define EMOTE_VISIBLE  1
#define EMOTE_HEARABLE 2

// Emotes
var/global/list/emotes_list = list()

/hook/startup/proc/populate_emotes()
	var/paths = typesof(/datum/emote)
	. = length(paths)
	for(var/T in paths)
		var/datum/emote/E = new T
		if(!E.key)
			del(E)
			continue
		emotes_list[E.key] = E


/datum/emote
	var/key = ""
	var/message = ""
	var/r_message =  ""
	var/m_type = EMOTE_VISIBLE

/datum/emote/proc/act(var/mob/living/carbon/human/H)
	var/russified = H.client && (H.client.prefs.toggles & RUS_AUTOEMOTES)
	if(russified)
		return H.custom_emote(m_type, r_message)
	else
		return H.custom_emote(m_type, message)

/datum/emote/select
	var/target_message = ""
	var/r_target_message = ""
	var/range = null

	proc/get_target(var/mob/living/carbon/human/H)
		return input(H) as null|mob in view(H, range ? range : world.view)

	act(var/mob/living/carbon/human/H)
		var/russified = H.client && (H.client.prefs.toggles & RUS_AUTOEMOTES)
		var/mob/living/carbon/human/target = get_target(H)
		if(!target || target==H)
			if(message)
				return ..()
			else
				return null
		else if(target in view(H, range ? range : world.view))
			if(russified)
				return H.custom_emote(m_type, replacetext(r_target_message,"@target", target))
			else
				return H.custom_emote(m_type, replacetext(target_message,"@target", target))

/*
/datum/emote/select/ask
	range = 1
	var/ask_msg = ""

	act(var/mob/living/carbon/human/H)
		var/russified = H.client && (H.client.prefs.toggles & RUS_AUTOEMOTES)
		var/mob/living/carbon/human/target = get_target(H)
		if(!target || target==H)
			if(message)
				return ..()
			else
				return null
		else
			if(russified)
				return H.custom_emote(m_type, replacetext(r_target_message,"@target", target))
			else
				return H.custom_emote(m_type, replacetext(target_message,"@target", target))
*/

////EMOTES////

/datum/emote/airguitar
	key = "airguitar"
	message = "is strumming the air and headbanging like a safari chimp."
	r_message = "èãðàåò íà âîîáðàæàåìîé ãèòàðå è òð&#255;ñ¸ò ãîëîâîé â òàêò."
	act(var/mob/living/carbon/human/H)
		if(!H.restrained())
			return ..()
		return null

/datum/emote/blink
	key = "blink"
	message = "blinks."
	r_message = "ìîðãàåò."

/datum/emote/blink_r
	key = "blink_r"
	message = "blinks rapidly."
	r_message = "÷àñòî ìîðãàåò."

/datum/emote/blush
	key = "blush"
	message = "blushes."
	r_message = "êðàñíååò."

/datum/emote/choke
	key = "choke"
	message = "chokes!"
	r_message = "çàäûõàåòñ&#255;!"

/datum/emote/chuckle
	key = "chuckle"
	message = "chuckles."
	r_message = "ïîñìåèâàåòñ&#255;."

/datum/emote/clap
	key = "clap"
	message = "claps."
	r_message = "õëîïàåò â ëàäîøè."
	m_type = EMOTE_HEARABLE
	act(var/mob/living/carbon/human/H)
		if (!H.restrained())
			return ..()

/datum/emote/clear
	key = "clear"
	message = "clears /his throat"
	r_message = "ïðî÷èùàåò ñâîå ãîðëî."

/datum/emote/collapse
	key = "collapse"
	message = "collapses!"
	r_message = "ïàäàåò!"
	m_type = EMOTE_HEARABLE
	act(var/mob/living/carbon/human/H)
		H.Paralyse(2)
		return ..()

/datum/emote/cough
	key = "cough"
	message = "coughs!"
	r_message = "êàøë&#255;åò!"

/datum/emote/cry
	key = "cry"
	message = "cries."
	r_message = "ïëà÷åò."

/datum/emote/deathgasp
	key = "deathgasp"
	act(var/mob/living/carbon/human/H)
		return H.custom_emote(EMOTE_VISIBLE, H.species.death_message)

/datum/emote/drool
	key = "drool"
	message = "drools."
	r_message = "ïóñêàåò ñëþíè."

/datum/emote/eyebrow
	key = "eyebrow"
	message = "raises an eyebrow."
	r_message = "âîïðîñèòåëüíî ïîäíèìàåò áðîâü."

/datum/emote/faint
	key = "faint"
	message = "faints."
	r_message = "ïàäàåò â îáìîðîê."
	act(var/mob/living/carbon/human/H)
		if(!H.sleeping)
			. = ..()
			H.sleeping += 10 //Short-short nap

/datum/emote/flap
	key= "flap"
	message = "flaps wings."
	r_message = "õëîïàåò êðûëü&#255;ìè."
	act(var/mob/living/carbon/human/H)
		if (!H.restrained())
			return ..()

/datum/emote/flap_a
	key = "flap_a"
	message = "flaps wings ANGRILY!"
	r_message = "ÓÃÐÎÆÀÞÙÅ õëîïàåò êðûëü&#255;ìè!"
	act(var/mob/living/carbon/human/H)
		if (!H.restrained())
			return ..()

/datum/emote/frown
	key = "frown"
	message = "frowns."
	r_message = "õìóðèòñ&#255;."

/datum/emote/gasp
	key = "gasp"
	message = "gasps!"
	r_message = "çàäûõàåòñ&#255;!"

/datum/emote/giggle
	key = "giggle"
	message = "giggles."
	r_message = "õèõèêàåò."

/datum/emote/grin
	key = "grin"
	message = "grins."
	r_message = "óõìûë&#255;åòñ&#255;."

/datum/emote/groan
	key = "groan"
	message = "groans!"
	r_message = "óñòàëî ñòîíåò!"

/datum/emote/grumble
	key = "grumble"
	message = "grumbles!"
	r_message = "âîð÷èò!"

/datum/emote/hem
	key = "hem"
	message = "hems"
	r_message = "õìûêàåò."

/datum/emote/hum
	key = "hum"
	message = "hums."
	r_message = "íàïåâàåò ñåáå ïîä íîñ."

/datum/emote/laugh
	key = "laugh"
	message = "laughs."
	r_message = "ñìå¸òñ&#255;."

/datum/emote/moan
	key = "moan"
	message = "moans!"
	r_message = "ñòîíåò!"

/datum/emote/mumble
	key = "mumble"
	message = "mumbles!"
	r_message = "áîðìî÷åò ÷òî-òî íåâí&#255;òíîå."
	m_type = EMOTE_HEARABLE

/datum/emote/nod
	key = "nod"
	message = "nods."
	r_message = "êèâàåò."

/datum/emote/pale
	key = "pale"
	message = "goes pale for a second."
	r_message = "áëåäíååò."

/datum/emote/raise
	key = "raise"
	message = "raises a hand."
	r_message = "ïîäíèìàåò ðóêó ââåðõ."
	act(var/mob/living/carbon/human/H)
		if (!H.restrained())
			return ..()

/datum/emote/scream
	key = "scream"
	message = "screams!"
	r_message = "êðè÷èò!"

/datum/emote/shake
	key = "shake"
	message = "shakes head."
	r_message = "ïîêà÷èâàåò ãîëîâîé."

/datum/emote/shiver
	key = "shiver"
	message = "shivers."
	r_message = "äðîæèò."
	m_type = EMOTE_HEARABLE

/datum/emote/shrug
	key = "shrug"
	message = "shrugs."
	r_message = "ïîæèìàåò ïëå÷àìè."

/datum/emote/sigh
	key = "sigh"
	message = "sighs."
	r_message = "âçäûõàåò."

/datum/emote/smile
	key = "smile"
	message = "smiles."
	r_message = "óëûáàåòñ&#255;."

/datum/emote/sneeze
	key = "sneeze"
	message = "sneezes."
	r_message = "÷èõàåò."

/datum/emote/sniff
	key = "sniff"
	message = "sniffs."
	r_message = "øìûãàåò íîñîì."
	m_type = EMOTE_HEARABLE

/datum/emote/snore
	key = "snore"
	message = "snores."
	r_message = "ñîïèò."

/datum/emote/tremble
	key = "tremble"
	message = "trembles in fear!"
	r_message = "äðîæèò îò óæàñà!"

/datum/emote/twitch
	key = "twitch"
	message = "twitches violently."
	r_message = "&#255;ðîñòíî äåðãàåòñ&#255;."

/datum/emote/twitch_s
	key = "twitch_s"
	message = "twitches."
	r_message = "äåðãàåòñ&#255;."

/datum/emote/wave
	key = "wave"
	message = "waves."
	r_message = "ìàøåò ðóêîé."

/datum/emote/whimper
	key = "whimper"
	message = "whimpers."
	r_message = "âñõëèïûâàåò."

/datum/emote/whistle
	key = "whistle"
	message = "whistles!"
	r_message = "ñâèñòèò!"

/datum/emote/wink
	key = "wink"
	message = "winks."
	message = "ïîäìèãèâàåò."

/datum/emote/yawn
	key = "yawn"
	message = "yawns."
	r_message = "çåâàåò."
	m_type = EMOTE_HEARABLE
	act(var/mob/living/carbon/human/H)
		if (!istype(H.wear_mask, /obj/item/clothing/mask/muzzle))
			return ..()

////SELECT////

/datum/emote/select/airkiss
	key = "airkiss"
	message = "blowing a kiss."
	r_message = "îòïðàâë&#255;åò âîçäóøíûé ïîöåëóé."
	target_message = "blowing a kiss to @target."
	r_target_message = "îòïðàâë&#255;åò âîçäóøíûé ïîöåëóé @target."
	act(var/mob/living/carbon/human/H)
		if(!H.handcuffed)
			return ..()

/datum/emote/select/bow
	key = "bow"
	message = "bows."
	r_message = "êëàí&#255;åòñ&#255;."
	target_message = "bows to @target."
	r_target_message = "êëàí&#255;åòñ&#255; @target."
	act(var/mob/living/carbon/human/H)
		if(!H.buckled)
			return ..()

/datum/emote/select/glare
	key = "glare"
	message = "glares."
	r_message = "çëîáíî ñìîòðèò."
	target_message = "glares at @target."
	r_target_message = "ñìîòðèò íà @target ñî çëîáîé."

/datum/emote/select/look
	key = "look"
	message = "looks."
	r_message = "îñìàòðèâàåòñ&#255;."
	target_message = "looks at @target."
	r_target_message = "ñìîòðèò íà @target."

/datum/emote/select/salute
	key = "salute"
	message = "salutes."
	r_message = "îòäàåò ÷åñòü."
	target_message = "salutes to @target."
	r_target_message = "îòäàåò ÷åñòü @target."
	act(var/mob/living/carbon/human/H)
		if(!H.handcuffed)
			return ..()

/datum/emote/select/stare
	key = "stare"
	message = "stares."
	r_message = "âíèìàòåëüíî ñìîòðèò íà ïðîèñõîä&#255;ùåå."
	target_message = "stares at @target."
	r_target_message = "ï&#255;ëèòñ&#255; íà @target."

////SELECT LOCAL////

/datum/emote/select/local/cuddle
	key = "cuddle"
	target_message = "cuddles @target."
	r_target_message = "ïðèæèìàåòñ&#255; ê @target."
	act(var/mob/living/carbon/human/H)
		if(!H.restrained())
			..()

/datum/emote/select/local/dap
	key = "dap"
	message = "sadly can't find anybody to give daps to, and daps himself. Shameful."
	r_message = "íå íàéä&#255; íèêîãî ð&#255;äîì ñ ñîáîé, äåëàåò  áðîôèñò ñàì ñ ñîáîé.  Æàëêîå çðåëèùå."
	target_message = "gives daps to @target."
	r_target_message = "äåëàåò áðîôèñò ñ @target."
	act(var/mob/living/carbon/human/H)
		if(!H.restrained())
			..()

/datum/emote/select/local/handshake
	key = "handshake"
	target_message = "shakes hands with @target."
	r_target_message = "æìåò ðóêè ñ @target."

/datum/emote/select/local/highfive
	key = "five"
	message = "can't find anybody to give high five to."
	r_message = "íå íàõîäèò íèêîãî, êîìó ìîæíî áûëî áû äàòü ï&#255;òü."
	target_message = "gives hihg five to @target."
	r_target_message = "äàåò ï&#255;òü @target"

/datum/emote/select/local/hug
	key = "hug"
	message = "hugs itself."
	r_message = "îáíèìàåò ñåá&#255;."
	target_message = "hugs @target."
	r_target_message = "îáíèìàåò @target."

/datum/emote/select/local/kiss
	key = "kiss"
	target_message = "kisses @target."
	r_target_message = "öåëóåò @target."

/datum/emote/select/local/snuggle
	key = "snuggle"
	target_message = "snuggles @target."
	r_target_message = "ïðèæèìàåò @target ê ñåáå."

////Special////

/datum/emote/signal
	key = "signal"
	m_type = EMOTE_VISIBLE

	act(var/mob/living/carbon/human/H)
		var/russified = H.client && (H.client.prefs.toggles & RUS_AUTOEMOTES)
		var/t1 = input("How many fingers will you raise?", "Ammount", 2) as num
		if (isnum(t1))
			if (t1 <= 0) return
			switch(t1)
				if (1 to 5)
					if((H.r_hand || !H.get_organ("r_hand")) && (H.l_hand  || !H.get_organ("l_hand")))
						H << "<span class='warning'>Your need at least one free hand for this</span>"
						return
					if(!russified)
						return H.custom_emote(m_type, "raises [t1] finger\s.")
					else
						var/emote = "ïîäíèìàåò [t1] ïàëüöåâ"
						switch(t1)
							if(1)   emote = "ïîäíèìàåò [t1] ïàëåö."
							if(2 to 4) emote = "ïîäíèìàåò [t1] ïàëåöà."
							if(5)   emote = "ïîäíèìàåò [t1] ïàëüöåâ."
						return H.custom_emote(m_type, emote)
				if (6 to 10)
					if((H.r_hand || !H.get_organ("r_hand")) || (H.l_hand  || !H.get_organ("l_hand")))
						H << "<span class='warning'>Your need at least two free hands for this</span>"
						return
					if(russified)
						return H.custom_emote(m_type, "ïîäíèìàåò [t1] ïàëüöåâ.")
					else
						return H.custom_emote(m_type, "raises [t1] fingers.")

#undef EMOTE_VISIBLE
#undef EMOTE_HEARABLE
