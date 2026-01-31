--유스 베르크 - 폴른 디 엠파이어
local s,id=GetID()
function s.initial_effect(c)
	c:EnableReviveLimit()
	Link.AddProcedure(c,nil,2,4,s.lcheck)
	
end
s.listed_names={CARD_KNIGHT_YOUTH}
function s.lcheck(g,lc,sumtype,tp)
	return g:IsExists(Card.IsCode,1,nil,CARD_KNIGHT_YOUTH,lc,sumtype,tp) and g:CheckDifferentPropertyBinary(Card.GetRace,lc,sumtype,tp) and g:CheckSameProperty(Card.GetAttribute,lc,sumtype,tp)
end
