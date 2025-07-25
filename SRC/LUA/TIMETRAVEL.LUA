-- TIMETRAVEL.LUA
-- Code by LeonardoTheMutant
--
-- Script responsible for time traveling in MM maps

--freeslots
freeslot("MT_TIMESIGN_P", "MT_TIMESIGN_F", "SPR_TMSN", "S_TIMESIGN_P", "S_TIMESIGN_F")
freeslot("S_TIMESIGN_P_SPIN1", "S_TIMESIGN_P_SPIN2", "S_TIMESIGN_P_SPIN3", "S_TIMESIGN_P_SPIN4", "S_TIMESIGN_P_SPIN5", "S_TIMESIGN_P_SPIN6", "S_TIMESIGN_P_SPIN7")
freeslot("S_TIMESIGN_F_SPIN1", "S_TIMESIGN_F_SPIN2", "S_TIMESIGN_F_SPIN3", "S_TIMESIGN_F_SPIN4", "S_TIMESIGN_F_SPIN5", "S_TIMESIGN_F_SPIN6", "S_TIMESIGN_F_SPIN7")

--
-- FUTURE SIGN
--
mobjinfo[MT_TIMESIGN_F]={
	--$Title Time Warp sign (Future)
	--$Sprite TMSNB0
	--$NotAngled
	doomednum = 36,
	spawnstate = S_TIMESIGN_F,
	radius = 2097152, --32*FU
	height = 4194304, --64*FU
	flags = MF_SPECIAL
}
--Idle state
states[S_TIMESIGN_F] = {
	sprite = SPR_TMSN,
	frame = B,
	tics = -1,
	nextstate = S_TIMESIGN_F
}
--Spinning states
states[S_TIMESIGN_F_SPIN1] = {
	sprite = SPR_TMSN,
	frame = C,
	tics = 1,
	nextstate = S_TIMESIGN_F_SPIN2
}
states[S_TIMESIGN_F_SPIN2] = {
	sprite = SPR_TMSN,
	frame = D,
	tics = 1,
	nextstate = S_TIMESIGN_F_SPIN3
}
states[S_TIMESIGN_F_SPIN3] = {
	sprite = SPR_TMSN,
	frame = E,
	tics = 1,
	nextstate = S_TIMESIGN_F_SPIN4
}
states[S_TIMESIGN_F_SPIN4] = {
	sprite = SPR_TMSN,
	frame = G,
	tics = 1,
	nextstate = S_TIMESIGN_F_SPIN5
}
states[S_TIMESIGN_F_SPIN5] = {
	sprite = SPR_TMSN,
	frame = C,
	tics = 1,
	nextstate = S_TIMESIGN_F_SPIN6
}
states[S_TIMESIGN_F_SPIN6] = {
	sprite = SPR_TMSN,
	frame = D,
	tics = 1,
	nextstate = S_TIMESIGN_F_SPIN7
}
states[S_TIMESIGN_F_SPIN7] = {
	sprite = SPR_TMSN,
	frame = E,
	tics = 1,
	nextstate = S_TIMESIGN_F
}

--
-- PAST SIGN
--
mobjinfo[MT_TIMESIGN_P]={
	--$Title Time Warp sign (Past)
	--$Sprite TMSNA0
	--$NotAngled
	doomednum = 37,
	spawnstate = S_TIMESIGN_P,
	radius = 2097152, --32*FU
	height = 4194304, --64*FU
	flags = MF_SPECIAL
}
--Idle state
states[S_TIMESIGN_P] = {
	sprite = SPR_TMSN,
	frame = A,
	tics = -1,
	nextstate = S_TIMESIGN_P
}
--Spinning states
states[S_TIMESIGN_P_SPIN1] = {
	sprite = SPR_TMSN,
	frame = C,
	tics = 1,
	nextstate = S_TIMESIGN_P_SPIN2
}
states[S_TIMESIGN_P_SPIN2] = {
	sprite = SPR_TMSN,
	frame = D,
	tics = 1,
	nextstate = S_TIMESIGN_P_SPIN3
}
states[S_TIMESIGN_P_SPIN3] = {
	sprite = SPR_TMSN,
	frame = E,
	tics = 1,
	nextstate = S_TIMESIGN_P_SPIN4
}
states[S_TIMESIGN_P_SPIN4] = {
	sprite = SPR_TMSN,
	frame = F,
	tics = 1,
	nextstate = S_TIMESIGN_P_SPIN5
}
states[S_TIMESIGN_P_SPIN5] = {
	sprite = SPR_TMSN,
	frame = C,
	tics = 1,
	nextstate = S_TIMESIGN_P_SPIN6
}
states[S_TIMESIGN_P_SPIN6] = {
	sprite = SPR_TMSN,
	frame = D,
	tics = 1,
	nextstate = S_TIMESIGN_P_SPIN7
}
states[S_TIMESIGN_P_SPIN7] = {
	sprite = SPR_TMSN,
	frame = A,
	tics = 1,
	nextstate = S_TIMESIGN_P
}

local TimeTravel_ShiftX, TimeTravel_ShiftY, TimeTravel_ShiftX2, TimeTravel_ShiftY2, temp

--Get the lengths between different Time Zones (if map has Time Travel)
addHook("PlayerSpawn", function (p)
	if (gametype != GT_LTMMURDERMYSTERY) return end

	TimeTravel_ShiftX = 0
	TimeTravel_ShiftY = 0
	TimeTravel_ShiftX2 = 0
	TimeTravel_ShiftY2 = 0

	--Shift X (Past, Present, Bad Future)
	temp = tonumber(mapheaderinfo[gamemap].mm_timetravel_shiftx)
	if (temp) then TimeTravel_ShiftX = temp end

	--Shift Y (Past, Present, Bad Future)
	temp = tonumber(mapheaderinfo[gamemap].mm_timetravel_shifty)
	if (temp) then TimeTravel_ShiftY = temp end

	--Shift X 2 (Good Future)
	temp = tonumber(mapheaderinfo[gamemap].mm_timetravel_shiftx2)
	if (temp) then TimeTravel_ShiftX2 = temp end

	--Shift Y 2 (Good Future)
	temp = tonumber(mapheaderinfo[gamemap].mm_timetravel_shifty2)
	if (temp) then TimeTravel_ShiftY2 = temp end

	if (MM.debug) and (TimeTravel_ShiftX or TimeTravel_ShiftY or TimeTravel_ShiftX2 or TimeTravel_ShiftY2)
		CONS_Printf(p, "\x82Map's Time Travel shift values")
		CONS_Printf(p, "X1: \x81"..TimeTravel_ShiftX.."\x80 ("..fixint(TimeTravel_ShiftX)..")")
		CONS_Printf(p, "Y1: \x81"..TimeTravel_ShiftY.."\x80 ("..fixint(TimeTravel_ShiftY)..")")
		CONS_Printf(p, "X2: \x81"..TimeTravel_ShiftX2.."\x80 ("..fixint(TimeTravel_ShiftX2)..")")
		CONS_Printf(p, "Y2: \x81"..TimeTravel_ShiftY2.."\x80 ("..fixint(TimeTravel_ShiftY2)..")")
	end
end)

addHook("PlayerThink", function(p)
	if ((gametype != GT_LTMMURDERMYSTERY) or (not p.mm) or (not p.mm.timetravel) or (not valid(p.mo))) return end
	
	if (p.mm.timetravel.timesign)
		if (p.speed >= 2949120) --45*FU
			p.mm.timetravel.warptimer = $ + 1
			P_SpawnMobjFromMobj(p.mo,0,0,0,MT_SUPERSPARK) --Time Warp trail
			
			--Time Warp itself
			if ((p.mm.timetravel.warptimer >= 140))
				if (p.mm.timetravel.timesign == TWS_PAST) --warping to the more Past stage
					switch(p.mm.timetravel.timezone, {
						[TIMEZONE_FUTURE_BAD] = do --warp from Bad Future
							p.mm.timetravel.timezone = TIMEZONE_PRESENT
							P_MoveOrigin(p.mo, p.mo.x - TimeTravel_ShiftX, p.mo.y - TimeTravel_ShiftY, p.mo.z)
						end,
						[TIMEZONE_FUTURE_GOOD] = do --warp from Good Future
							p.mm.timetravel.timezone = TIMEZONE_PRESENT
							P_MoveOrigin(p.mo, p.mo.x - TimeTravel_ShiftX2, p.mo.y - TimeTravel_ShiftY2, p.mo.z)
						end,
						[TIMEZONE_PRESENT] = do --warp from present
							p.mm.timetravel.timezone = TIMEZONE_PAST
							P_MoveOrigin(p.mo, p.mo.x - TimeTravel_ShiftX, p.mo.y - TimeTravel_ShiftY, p.mo.z)
						end
					})
				else --warping to the more Future stage
					switch(p.mm.timetravel.timezone, {
						[TIMEZONE_PAST] = do --warp from Past
							p.mm.timetravel.timezone = TIMEZONE_PRESENT
							P_MoveOrigin(p.mo, p.mo.x + TimeTravel_ShiftX, p.mo.y + TimeTravel_ShiftY, p.mo.z)
						end,
						[TIMEZONE_PRESENT] = do --warp from Present
							if (MM.PlayerCount(ROLE_MURDERER))
								p.mm.timetravel.timezone = TIMEZONE_FUTURE_BAD
								P_MoveOrigin(p.mo, p.mo.x + TimeTravel_ShiftX, p.mo.y + TimeTravel_ShiftY, p.mo.z)
							else --You will never see the Good Future version of this level in a regular playthrough :)
								p.mm.timetravel.timezone = TIMEZONE_FUTURE_GOOD
								P_MoveOrigin(p.mo, p.mo.x + TimeTravel_ShiftX2, p.mo.y + TimeTravel_ShiftY2, p.mo.z)
							end
						end
					})
				end
				MM.StartFlashFX(p, 8, 0)
				--P_SpawnMobjFromMobj(p.mo,0,0,0,MT_THROWNEXPLOSION) --blast after a time warp (visual effect)
				S_StartSound(p.mo, sfx_mixup, p)
				p.mm.timetravel.timesign = TWS_NONE
				p.mm.timetravel.warptimer = 0
			end
		else
			--if you lose speed while being in warping substate you lose your "Warp Ticket"
			if (p.mm.timetravel.warptimer >= 70) then p.mm.timetravel.timesign = TWS_NONE end
			p.mm.timetravel.warptimer = 0
		end
	end
end)

--
-- SIGN OBJECT LOGIC
--

--Future
addHook("MapThingSpawn", function(mo) --Do not spawn the sign outside Murder Mystery
	if (gametype != GT_LTMMURDERMYSTERY)
		mo.state = 0
		return true
	end
end, MT_TIMESIGN_F)
addHook("TouchSpecial", function(special, toucher)
	if (gametype != GT_LTMMURDERMYSTERY) return end

	if (toucher) and valid(toucher.player) and (not toucher.player.spectator) and (toucher.player.mm.timetravel and (toucher.player.mm.timetravel.timesign != TWS_FUTURE)) and (not special.spinning)
		toucher.player.mm.timetravel.timesign = TWS_FUTURE
		S_StartSound(toucher.player.mo, sfx_cdpcm0, toucher.player)
		special.spinning = 8
	end

	return true
end, MT_TIMESIGN_F)
addHook("MobjThinker", function(mo)
	if (mo.spinning) and (mo.state == S_TIMESIGN_F)
		mo.state = S_TIMESIGN_F_SPIN1
		mo.spinning = $ - 1
	end
end, MT_TIMESIGN_F)

--Past
addHook("MapThingSpawn", function(mo) --Do not spawn the sign outside Murder Mystery
	if (gametype != GT_LTMMURDERMYSTERY)
		mo.state = 0
		return true
	end
end, MT_TIMESIGN_P)
addHook("TouchSpecial", function(special, toucher)
	if (gametype != GT_LTMMURDERMYSTERY) return end

	if (toucher) and valid(toucher.player) and (not toucher.player.spectator) and (toucher.player.mm.timetravel and (toucher.player.mm.timetravel.timesign != TWS_PAST)) and (not special.spinning)
		toucher.player.mm.timetravel.timesign = TWS_PAST
		S_StartSound(toucher.player.mo, sfx_cdpcm1, toucher.player)
		special.spinning = 8
	end

	return true
end, MT_TIMESIGN_P)
addHook("MobjThinker", function(mo)
	if (mo.spinning) and (mo.state == S_TIMESIGN_P)
		mo.state = S_TIMESIGN_P_SPIN1
		mo.spinning = $ - 1
	end
end, MT_TIMESIGN_P)
