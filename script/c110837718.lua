--풀메타리온 아슈라스타
local s,id=GetID()
function s.initial_effect(c)
	c:EnableReviveLimit()
	-- "Imaginary Actor" + 1 "Metarion" monster
	Fusion.AddProcMix(c,true,true,CARD_IMAG_ACT,aux.FilterBoolFunctionEx(Card.IsSetCard,SET_METARION))
	
end
