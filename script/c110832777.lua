--격류파의 총사령관 발레오스 리바이브
local s,id=GetID()
function s.initial_effect(c)
	c:EnableReviveLimit()
	Link.AddProcedure(c,s.matfilter,1,1)
	
end
s.listed_series={SET_BLUEWAVE}
function s.matfilter(c,scard,sumtype,tp)
	return c:IsCode(110832003)
end
