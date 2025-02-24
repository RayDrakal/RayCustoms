--메타리온 아슈라스타
local s,id=GetID()
function s.initial_effect(c)
	c:EnableReviveLimit()
	Fusion.AddProcMix(c,true,true,CARD_IMAG_ACT,aux.FilterBoolFunctionEx(Card.IsRace,RACE_WARRIOR))
	
end
