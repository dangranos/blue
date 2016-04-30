// At minimum every mob has a hear_say proc.

/mob/proc/hear_say(var/message, var/verb = "says", var/datum/language/language = null, var/alt_name = "",var/italics = 0, var/mob/speaker = null, var/sound/speech_sound, var/sound_vol)
	if(!client)
		return

	var/speaker_name = speaker.name
	if(istype(speaker, /mob/living/carbon/human))
		speaker_name = speaker:GetVoice()

	if(italics)
		message = "<i>[message]</i>"

	var/track = null
	if(istype(src, /mob/dead/observer))
		if(italics && client.prefs.chat_toggles & CHAT_GHOSTRADIO)
			return
		if(speaker_name != speaker.real_name && speaker.real_name)
			speaker_name = "[speaker.real_name] ([speaker_name])"
		track = "(<a href='byond://?src=\ref[src];track=\ref[speaker]'>follow</a>) "
		if(client.prefs.chat_toggles & CHAT_GHOSTEARS && speaker in view(src))
			message = "<b>[message]</b>"

	if(language)
		on_hear_say("<span class='game say'><span class='name'>[speaker_name]</span>[alt_name] [track][language.format_message(message, verb)]</span>")
	else
		on_hear_say("<span class='game say'><span class='name'>[speaker_name]</span>[alt_name] [track][verb], <span class='message'><span class='body'>\"[message]\"</span></span></span>")
	if (speech_sound && (get_dist(speaker, src) <= world.view && src.z == speaker.z))
		var/turf/source = speaker? get_turf(speaker) : get_turf(src)
		src.playsound_local(source, speech_sound, sound_vol, 1)

/mob/proc/on_hear_say(var/message)
	src << message

/mob/living/silicon/on_hear_say(var/message)
	var/time = say_timestamp()
	src << "[time] [message]"

/mob/proc/hear_radio(var/message, var/verb="says", var/datum/language/language=null, var/part_a, var/part_b, var/mob/speaker = null, var/hard_to_hear = 0, var/vname ="")

	if(!client)
		return

	var/speaker_name = get_hear_name(speaker, hard_to_hear, vname)

	if(language)
		message = language.format_message_radio(message, verb)
	else
		message = "[verb], <span class=\"body\">\"[message]\"</span>"

	on_hear_radio(part_a, speaker_name, part_b, message)

/proc/say_timestamp()
	return "<span class='say_quote'>\[[worldtime2text()]\]</span>"

/mob/proc/get_hear_name(var/mob/speaker, hard_to_hear, vname)
	if(hard_to_hear) return "unknown"
	else
		if(istype(speaker, /mob/living/carbon/human))
			var/voice = speaker:GetVoice()
			if(voice)
				return voice
	return vname ? vname : speaker.name


/mob/living/silicon/ai/get_hear_name(speaker, hard_to_hear, vname)
	var/speaker_name = ..()
	if(hard_to_hear) return speaker_name

	var/changed_voice
	var/jobname // the mob's "job"
	var/mob/living/carbon/human/impersonating //The crew member being impersonated, if any.

	if (ishuman(speaker))
		var/mob/living/carbon/human/H = speaker

		if(H.wear_mask && istype(H.wear_mask,/obj/item/clothing/mask/gas/voice))
			changed_voice = 1
			var/mob/living/carbon/human/I

			for(var/mob/living/carbon/human/M in mob_list)
				if(M.real_name == speaker_name)
					I = M
					break

			// If I's display name is currently different from the voice name and using an agent ID then don't impersonate
			// as this would allow the AI to track I and realize the mismatch.
			if(I && (I.name == speaker_name || !I.wear_id || !istype(I.wear_id,/obj/item/weapon/card/id/syndicate)))
				impersonating = I
				jobname = impersonating.get_assignment()
			else
				jobname = "Unknown"
		else
			jobname = H.get_assignment()

	else if (iscarbon(speaker)) // Nonhuman carbon mob
		jobname = "No id"
	else if (isAI(speaker))
		jobname = "AI"
	else if (isrobot(speaker))
		jobname = "Cyborg"
	else if (istype(speaker, /mob/living/silicon/pai))
		jobname = "Personal AI"
	else
		jobname = "Unknown"

	if(changed_voice)
		if(impersonating)
			return "<a href=\"byond://?src=\ref[src];trackname=[rhtml_encode(speaker_name)];track=\ref[impersonating]\">[speaker_name] ([jobname])</a>"
		else
			return "[speaker_name] ([jobname])"
	else
		return "<a href=\"byond://?src=\ref[src];trackname=[rhtml_encode(speaker_name)];track=\ref[speaker]\">[speaker_name] ([jobname])</a>"

/mob/dead/observer/get_hear_name(var/mob/speaker, hard_to_hear, vname)
	var/speaker_name = ..()
	if(ishuman(speaker) && speaker_name != speaker.real_name && !isAI(speaker)) //Announce computer and various stuff that broadcasts doesn't use it's real name but AI's can't pretend to be other mobs.
		speaker_name = "[speaker.real_name] ([speaker_name])"
	return "[speaker_name] (<a href='byond://?src=\ref[src];track=\ref[speaker]'>follow</a>)"

/mob/proc/on_hear_radio(part_a, speaker_name, part_b, message)
	src << "[part_a][speaker_name][part_b][message]"

/mob/living/silicon/on_hear_radio(part_a, speaker_name, part_b, message)
	var/time = say_timestamp()
	src << "[time][part_a][speaker_name][part_b][message]"

/mob/proc/hear_signlang(var/message, var/verb = "gestures", var/datum/language/language, var/mob/speaker = null)
	if(!client)
		return

	if(say_understands(speaker, language))
		message = "<B>[src]</B> [verb], \"[message]\""
	else
		message = "<B>[src]</B> [verb]."

	if(src.status_flags & PASSEMOTES)
		for(var/obj/item/weapon/holder/H in src.contents)
			H.show_message(message)
		for(var/mob/living/M in src.contents)
			M.show_message(message)
	src.show_message(message)

/mob/proc/hear_sleep(var/message)
	var/heard = ""
	if(prob(15))
		var/list/punctuation = list(",", "!", ".", ";", "?")
		var/list/messages = text2list(message, " ")
		var/R = rand(1, messages.len)
		var/heardword = messages[R]
		if(copytext(heardword,1, 1) in punctuation)
			heardword = copytext(heardword,2)
		if(copytext(heardword,-1) in punctuation)
			heardword = copytext(heardword,1,lentext(heardword))
		heard = "<span class = 'game_say'>...You hear something about...[heardword]</span>"

	else
		heard = "<span class = 'game_say'>...<i>You almost hear someone talking</i>...</span>"

	src << heard
