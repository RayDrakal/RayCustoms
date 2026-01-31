--유스 베르크 - 폴른 더 저스티스
local s,id=GetID()
function s.initial_effect(c)
	c:EnableReviveLimit()
	Link.AddProcedure(c,aux.FilterBoolFunctionEx(Card.IsCode,CARD_KNIGHT_YOUTH),1,1)
	
end
s.listed_names={CARD_KNIGHT_YOUTH}
