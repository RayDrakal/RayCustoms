--잔향의 세이렌 에프테리아
local s,id=GetID()
function s.initial_effect(c)
    c:EnableReviveLimit()
	--link summon
	Link.AddProcedure(c,nil,2,2,s.lcheck)
	
end
function s.lcheck(g,lc,sumtype,tp)
	return g:IsExists(Card.IsSetCard,1,nil,SET_ZANKYA,lc,sumtype,tp)
end
