#define SCRAMBLE_CACHE_LEN 20

/*
	Datum based languages. Easily editable and modular.
*/

/datum/language
	var/name = "an unknown language"  // Fluff name of language if any.
	var/desc = "A language."          // Short description for 'Check Languages'.
	var/speech_verb = "says"          // 'says', 'hisses', 'farts'.
	var/ask_verb = "asks"             // Used when sentence ends in a ?
	var/exclaim_verb = "exclaims"     // Used when sentence ends in a !
	var/whisper_verb                  // Optional. When not specified speech_verb + quietly/softly is used instead.
	var/signlang_verb = list("signs", "gestures") // list of emotes that might be displayed if this language has NONVERBAL or SIGNLANG flags
	var/colour = "body"               // CSS style to use for strings in this language.
	var/key = "x"                     // Character used to speak in language eg. :o for Unathi.
	var/flags = 0                     // Various language flags.
	var/native                        // If set, non-native speakers will have trouble speaking.
	var/list/syllables                // Used when scrambling text for a non-speaker.
	var/list/space_chance = 55        // Likelihood of getting a space in the random scramble string

/datum/language/proc/get_random_name(var/gender, name_count=2, syllable_count=4, syllable_divisor=2)
	if(!syllables || !syllables.len)
		if(gender==FEMALE)
			return capitalize(pick(first_names_female)) + " " + capitalize(pick(last_names))
		else
			return capitalize(pick(first_names_male)) + " " + capitalize(pick(last_names))

	var/full_name = ""
	var/new_name = ""

	for(var/i = 0;i<name_count;i++)
		new_name = ""
		for(var/x = rand(Floor(syllable_count/syllable_divisor),syllable_count);x>0;x--)
			new_name += pick(syllables)
		full_name += " [capitalize(lowertext(new_name))]"

	return "[trim(full_name)]"

/datum/language
	var/list/scramble_cache = list()

/datum/language/proc/scramble(var/input)

	if(!syllables || !syllables.len)
		return stars(input)

	// If the input is cached already, move it to the end of the cache and return it
	if(input in scramble_cache)
		var/n = scramble_cache[input]
		scramble_cache -= input
		scramble_cache[input] = n
		return n

	var/input_size = length(input)
	var/scrambled_text = ""
	var/capitalize = 1

	while(length(scrambled_text) < input_size)
		var/next = pick(syllables)
		if(capitalize)
			next = capitalize(next)
			capitalize = 0
		scrambled_text += next
		var/chance = rand(100)
		if(chance <= 5)
			scrambled_text += ". "
			capitalize = 1
		else if(chance > 5 && chance <= space_chance)
			scrambled_text += " "

	scrambled_text = trim(scrambled_text)
	var/ending = copytext(scrambled_text, length(scrambled_text))
	if(ending == ".")
		scrambled_text = copytext(scrambled_text,1,length(scrambled_text)-1)
	var/input_ending = copytext(input, input_size)
	if(input_ending in list("!","?","."))
		scrambled_text += input_ending

	// Add it to cache, cutting old entries if the list is too long
	scramble_cache[input] = scrambled_text
	if(scramble_cache.len > SCRAMBLE_CACHE_LEN)
		scramble_cache.Cut(1, scramble_cache.len-SCRAMBLE_CACHE_LEN-1)

	return scrambled_text

/datum/language/proc/format_message(message, verb)
	return "[verb], <span class='message'><span class='[colour]'>\"[capitalize(message)]\"</span></span>"

/datum/language/proc/format_message_plain(message, verb)
	return "[verb], \"[capitalize(message)]\""

/datum/language/proc/format_message_radio(message, verb)
	return "[verb], <span class='[colour]'>\"[capitalize(message)]\"</span>"

/datum/language/proc/get_talkinto_msg_range(message)
	// if you yell, you'll be heard from two tiles over instead of one
	return (copytext(message, length(message)) == "!") ? 2 : 1

/datum/language/proc/broadcast(var/mob/living/speaker,var/message,var/speaker_mask)
	log_say("[key_name(speaker)] : ([name]) [message]")

	if(!speaker_mask) speaker_mask = speaker.name
	message = format_message(message, get_spoken_verb(message))

	for(var/mob/player in player_list)
		player.hear_broadcast(src, speaker, speaker_mask, message)

/mob/proc/hear_broadcast(var/datum/language/language, var/mob/speaker, var/speaker_name, var/message)
	if((language in languages) && language.check_special_condition(src))
		var/msg = "<i><span class='game say'>[language.name], <span class='name'>[speaker_name]</span> [message]</span></i>"
		src << msg

/mob/new_player/hear_broadcast(var/datum/language/language, var/mob/speaker, var/speaker_name, var/message)
	return

/mob/observer/dead/hear_broadcast(var/datum/language/language, var/mob/speaker, var/speaker_name, var/message)
	if(speaker.name == speaker_name || antagHUD)
		src << "<i><span class='game say'>[language.name], <span class='name'>[speaker_name]</span> ([ghost_follow_link(speaker, src)]) [message]</span></i>"
	else
		src << "<i><span class='game say'>[language.name], <span class='name'>[speaker_name]</span> [message]</span></i>"

/datum/language/proc/check_special_condition(var/mob/other)
	return 1

/datum/language/proc/get_spoken_verb(var/msg_end)
	switch(msg_end)
		if("!")
			return exclaim_verb
		if("?")
			return ask_verb
	return speech_verb

/datum/language/proc/can_speak_special(var/mob/speaker)
	return 1

// Language handling.
/mob/proc/add_language(var/language)

	var/datum/language/new_language = all_languages[language]

	if(!istype(new_language) || (new_language in languages))
		return 0

	languages.Add(new_language)
	set_language_key(new_language, new_language.key)
	return 1

/mob/proc/set_language_key(var/datum/language/language, var/key = "")
	// If we don't know that language or key have wrong format
	if(!language in languages || length(key)>1) return 0

	if(!key)
		for(var/n_key in list("2", "3", "4", "5", "6", "7", "8", "9"))
			if(!n_key in language_keys)
				key = n_key
				break
	else drop_language_key(language)
	if(key) language_keys[key] = language
	return 1

/mob/living/carbon/human/set_language_key(var/datum/language/language, var/key = "")
	if(!key && species && species.language == language.name)
		..(language, "1")
	..()

/mob/proc/drop_language_key(var/datum/language/language)
	for(var/key in language_keys)
		if(language_keys[key] == language)
			language_keys.Remove(key)

/mob/proc/remove_language(var/rem_language)
	var/datum/language/L = all_languages[rem_language]
	. = (L in languages)
	languages.Remove(L)
	drop_language_key(L)

/mob/living/remove_language(rem_language)
	var/datum/language/L = all_languages[rem_language]
	if(default_language == L)
		default_language = null
	return ..()

// Can we speak this language, as opposed to just understanding it?
/mob/proc/can_speak(datum/language/speaking)
	//Prevents someone from speaking a null language.
	if(speaking)
		return (speaking.can_speak_special(src) && (universal_speak || (speaking && (speaking.flags & INNATE)) || speaking in src.languages))
	else
		log_debug("[src] attempted to speak a null language.")
		return 0

//TBD
/mob/verb/check_languages()
	set name = "Check Known Languages"
	set category = "IC"
	set src = usr

	var/dat = "<b><font size = 5>Known Languages</font></b><br/><br/>"

	for(var/datum/language/L in languages)
		if(!(L.flags & NONGLOBAL))
			dat += "<b>[L.name] (:[L.key])</b><br/>[L.desc]<br/><br/>"

	src << browse(dat, "window=checklanguage")
	return

/mob/living/check_languages()
	var/dat = "<b><font size = 5>Known Languages</font></b><br/><br/>"

	if(default_language)
		dat += "Current default language: [default_language] - <a href='byond://?src=\ref[src];default_lang=reset'>reset</a><br/><br/>"

	for(var/datum/language/L in languages)
		if(!(L.flags & NONGLOBAL))
			var/key = russian_to_utf8(get_key_by_value(language_keys, L))
			if(!key) key = "no key"
			else key = ":[key]"
			dat += "<b>[L.name] (<a href='byond://?src=\ref[src];set_key=\ref[L]'>[key]</a>)</b>"
			if(L == default_language)
				dat += " - default - <a href='byond://?src=\ref[src];default_lang=reset'>reset</a><br/>[L.desc]<br/><br/>"
			else
				dat += " - <a href='byond://?src=\ref[src];default_lang=\ref[L]'>set default</a><br/>[L.desc]<br/><br/>"

	src << browse(dat, "window=checklanguage")

/mob/living/Topic(href, href_list)
	if(href_list["default_lang"])
		if(href_list["default_lang"] == "reset")
			set_default_language(null)
		else
			var/datum/language/L = locate(href_list["default_lang"])
			if(L && (L in languages))
				set_default_language(L)
		check_languages()
		return 1
	else if(href_list["set_key"])
		var/datum/language/L = locate(href_list["set_key"])
		if(L && (L in languages))
			var/new_key = "  "
			while(length(new_key) > 1)
				new_key = sanitize_key(input("Specify new key for [L.name]. Space for dropkey. Empty for exit.", "New key for [L.name]") as text)
			if(new_key)
				if(new_key == " ") drop_language_key(L)
				else if(set_language_key(L, new_key))
					usr << "<span class = 'notice'>New key for \"[L.name]\" is \"[new_key]\"</span>"
		check_languages()
		return 1
	else
		return ..()

#undef SCRAMBLE_CACHE_LEN
