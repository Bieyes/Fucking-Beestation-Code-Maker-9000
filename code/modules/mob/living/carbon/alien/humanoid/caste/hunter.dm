/mob/living/carbon/alien/humanoid/hunter
	name = "alien hunter"
	caste = "h"
	maxHealth = 200
	health = 200
	icon_state = "alienh"
	var/atom/movable/screen/leap_icon

/mob/living/carbon/alien/humanoid/hunter/create_internal_organs()
	internal_organs += new /obj/item/organ/alien/plasmavessel/small
	return ..()

//Hunter verbs

/mob/living/carbon/alien/humanoid/hunter/proc/toggle_leap(message = TRUE)
	leap_on_click = !leap_on_click
	leap_icon.icon_state = "leap_[leap_on_click ? "on" : "off"]"
	update_icons()
	if(message)
		to_chat(src, span_noticealien("You will now [leap_on_click ? "leap at" : "slash at"] enemies!"))

/mob/living/carbon/alien/humanoid/hunter/ClickOn(atom/A, params)
	face_atom(A)
	if(leap_on_click)
		leap_at(A)
	else
		return ..()

#define MAX_ALIEN_LEAP_DIST 7

/mob/living/carbon/alien/humanoid/hunter/proc/leap_at(atom/A)
	if(body_position == LYING_DOWN || HAS_TRAIT(src, TRAIT_IMMOBILIZED) || leaping)
		return

	if(!(COOLDOWN_FINISHED(src, pounce_cooldown)))
		to_chat(src, span_alertalien("You are too fatigued to pounce right now!"))
		return

	if(!has_gravity() || !A.has_gravity())
		to_chat(src, span_alertalien("It is unsafe to leap without gravity!"))
		//It's also extremely buggy visually, so it's balance+bugfix
		return

	leaping = TRUE
	//Because the leaping sprite is bigger than the normal one
	body_position_pixel_x_offset = -32
	body_position_pixel_y_offset = -32
	weather_immunities += "lava"
	update_icons()
	throw_at(A, MAX_ALIEN_LEAP_DIST, 1, src, FALSE, TRUE, callback = CALLBACK(src, PROC_REF(leap_end)))

#undef MAX_ALIEN_LEAP_DIST

/mob/living/carbon/alien/humanoid/hunter/proc/leap_end()
	leaping = FALSE
	body_position_pixel_x_offset = 0
	body_position_pixel_y_offset = 0
	weather_immunities -= "lava"
	update_icons()

/mob/living/carbon/alien/humanoid/hunter/throw_impact(atom/hit_atom, datum/thrownthing/throwingdatum)
	if(!leaping)
		return ..()

	COOLDOWN_START(src, pounce_cooldown, 30)
	if(hit_atom)
		if(isliving(hit_atom))
			var/mob/living/L = hit_atom
			var/blocked = FALSE
			if(ishuman(hit_atom))
				var/mob/living/carbon/human/H = hit_atom
				if(H.check_shields(src, 0, "the [name]", attack_type = LEAP_ATTACK))
					blocked = TRUE
			if(!blocked)
				L.visible_message(span_danger("[src] pounces on [L]!"), span_userdanger("[src] pounces on you!"))
				L.Paralyze(100)
				sleep(0.2 SECONDS)//Runtime prevention (infinite bump() calls on hulks)
				step_towards(src, L)
			else
				Paralyze(40, ignore_canstun = TRUE)

			toggle_leap(FALSE)
		else if(hit_atom.density && !hit_atom.CanPass(src, get_dir(hit_atom, src)))
			visible_message(span_danger("[src] smashes into [hit_atom]!"), span_alertalien("[src] smashes into [hit_atom]!"))
			Paralyze(40, ignore_canstun = TRUE)

		if(leaping) //check that toggles out of leaping mode if the alien gets hit or otherwise interrupted
			leaping = FALSE
			update_icons()
