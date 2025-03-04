--잔향의 세이렌 비비아나
local s,id=GetID()
function s.initial_effect(c)
    c:EnableReviveLimit()
	--Link Summon procedure
	Link.AddProcedure(c,s.matfilter,1,1)
	
end
function s.matfilter(c,lc,sumtype,tp)
	return c:IsLevelBelow(4) and c:IsAttribute(ATTRIBUTE_WATER,lc,sumtype,tp)
end
