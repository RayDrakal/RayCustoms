--천라수장 람브로스
local s,id=GetID()
function s.initial_effect(c)
	c:EnableReviveLimit()
    -- Link Summon
	Link.AddProcedure(c,aux.FilterBoolFunctionEx(Card.IsAttribute,ATTRIBUTE_WATER),2)
	
end
s.listed_names={CARD_MEGARANIKA}
