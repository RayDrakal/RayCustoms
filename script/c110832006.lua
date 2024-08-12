--만파의 대장군 크리스티아노스
local s,id=GetID()
function s.initial_effect(c)
	c:EnableReviveLimit()
	--Link Summon Procedure
	Link.AddProcedure(c,aux.FilterBoolFunctionEx(Card.IsSetCard,SET_BLUEWAVE),2)
	
end
s.listed_series={SET_BLUEWAVE}
