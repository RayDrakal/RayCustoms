--만파의 무희 사이프리아
local s,id=GetID()
function s.initial_effect(c)
	c:EnableReviveLimit()
	--link summon
	Link.AddProcedure(c,aux.FilterBoolFunctionEx(Card.IsAttribute,ATTRIBUTE_WATER),2)
	
end
s.listed_series={SET_BLUEWAVE}
