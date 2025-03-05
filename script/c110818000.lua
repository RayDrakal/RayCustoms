--해갑룡 타이달 보어레스 드레이크
local s,id=GetID()
function s.initial_effect(c)
    c:EnableReviveLimit()
	--Link Summon procedure: 2+ monsters, including a LIGHT Fiend monster
	Link.AddProcedure(c,nil,2,3,s.lcheck)
	--Increase ATK/DEF
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetValue(s.atkval)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e2)
	--Decrease ATK/DEF
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(0,LOCATION_MZONE)
	e3:SetValue(s.val)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e4)
	--All monsters on the opponent field becomes WATER
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetRange(LOCATION_MZONE)
	e5:SetTargetRange(0,LOCATION_MZONE)
	e5:SetCode(EFFECT_CHANGE_ATTRIBUTE)
	e5:SetValue(ATTRIBUTE_WATER)
	c:RegisterEffect(e5)
	--Banish
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(id,0))
	e6:SetCategory(CATEGORY_REMOVE)
	e6:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e6:SetProperty(EFFECT_FLAG_DELAY)
	e6:SetCode(EVENT_REMOVE)
	e6:SetRange(LOCATION_MZONE)
	e6:SetCountLimit(1,id)
	e6:SetTarget(s.remtg)
	e6:SetOperation(s.remop)
	c:RegisterEffect(e6)
end
function s.lcheck(g,lc,sumtype,tp)
	return g:IsExists(Card.IsAttribute,1,nil,ATTRIBUTE_WATER,lc,sumtype,tp)
end
function s.atkval(e,c)
	return Duel.GetFieldGroupCount(0,LOCATION_REMOVED,LOCATION_REMOVED)*100
end
function s.val(e,c)
	return Duel.GetFieldGroupCount(0,LOCATION_REMOVED,LOCATION_REMOVED)*(-100)
end
function s.remtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not Duel.IsPlayerAffectedByEffect(e:GetHandlerPlayer(),69832741) 
		and Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil)
		and Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,2,PLAYER_EITHER,LOCATION_ONFIELD+LOCATION_GRAVE)
end
function s.remop(e,tp,eg,ep,ev,re,r,rp)
	local g1=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	local g2=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,LOCATION_GRAVE,LOCATION_GRAVE,nil)
	if #g1>0 and #g2>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local sg1=g1:Select(tp,1,1,nil)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local sg2=g2:Select(tp,1,1,nil)
		sg1:Merge(sg2)
		Duel.HintSelection(sg1,true)
		Duel.Remove(sg1,POS_FACEUP,REASON_EFFECT)
	end
end
