/obj/effect/chess_spawn
	name = "Chess spawn"

/obj/effect/chess_spawn/New()
	var/letters = list("a","b","c","d","e","f","g","h")
	var/k = 1
	for(var/i=0;i<8;i++)
		k++
		for(var/j=0;j<8;j++)
			var/turf/T = locate(x+j,y-i,z)
//			T.contents.Cut()
			T.name = "[letters[j+1]][8-i]"
			if(k++%2) T.icon_state = "black"
			else T.icon_state = "white"
	spawn(0)
		del(src)

/obj/effect/chess_spawn_figures
	name = "Chess figures spawn"

/obj/effect/chess_spawn_figures/proc/make_negro(var/mob/living/carbon/human/H)
	H.change_skin_tone(-80)

/obj/effect/chess_spawn_figures/New()
	var/datum/job/job = job_master.GetJob("Assistant")
	for(var/j in list(1,6))
		if(job)
			for(var/i=0;i<8;i++)
				var/turf/T = locate(x+i,y-j,z)
				var/mob/living/carbon/human/H = new(T)
				job.equip(H)
				if(j == 6)
					make_negro(H)

	job = job_master.GetJob("Warden")
	if(job)
		for(var/j in list(0, 7))
			for(var/i in list(0,7))
				var/turf/T = locate(x+i,y-j,z)
				var/mob/living/carbon/human/H = new(T)
				job.equip(H)
				if(j == 7)
					make_negro(H)

	job = job_master.GetJob("Station Engineer")
	if(job)
		for(var/j in list(0, 7))
			for(var/i in list(2,5))
				var/turf/T = locate(x+i,y-j,z)
				var/mob/living/carbon/human/H = new(T)
				job.equip(H)
				if(j == 7)
					make_negro(H)

	job = job_master.GetJob("Cargo Technician")
	if(job)
		for(var/j in list(0, 7))
			for(var/i in list(1,6))
				var/turf/T = locate(x+i,y-j,z)
				var/mob/living/carbon/human/H = new(T)
				job.equip(H)
				if(j == 7)
					make_negro(H)

	job = job_master.GetJob("Captain")
	if(job)
		var/turf/T = locate(x+3,y-0,z)
		var/mob/living/carbon/human/H = new(T)
		job.equip(H)
	if(job)
		var/turf/T = locate(x+4,y-7,z)
		var/mob/living/carbon/human/H = new(T)
		job.equip(H)
		make_negro(H)


	job = job_master.GetJob("Head of Personnel")
	if(job)
		var/turf/T = locate(x+4,y-0,z)
		var/mob/living/carbon/human/H = new(T)
		job.equip(H)
	if(job)
		var/turf/T = locate(x+3,y-7,z)
		var/mob/living/carbon/human/H = new(T)
		job.equip(H)
		make_negro(H)
	spawn(0)
		del(src)