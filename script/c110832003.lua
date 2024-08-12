--만파의 사령관 발레오스
local s,id=GetID()
function s.initial_effect(c)
	c:EnableReviveLimit()
	--Link Summon Procedure
	Link.AddProcedure(c,aux.FilterBoolFunctionEx(Card.IsSetCard,SET_BLUEWAVE),2)
	
end
s.listed_series={SET_BLUEWAVE}
