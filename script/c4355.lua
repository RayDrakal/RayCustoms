--ジ・エンド・オブ・ストーム
function c4355.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(c4355.condition)
	e1:SetTarget(c4355.target)
	e1:SetOperation(c4355.activate)
	c:RegisterEffect(e1)
end
function c4355.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFieldCard(tp,LOCATION_SZONE,5):GetCounter(0x91)>=10
end
function c4355.filter2(c)
	return c:IsType(TYPE_MONSTER)
end
function c4355.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and c4355.filter2(chkc) and chkc~=e:GetHandler() end
	if chk==0 then return Duel.IsExistingTarget(c4355.filter2,tp,LOCATION_MZONE,LOCATION_MZONE,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.GetMatchingGroup(Card.IsDestructable,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c4355.activate(e,tp,eg,ep,ev,re,r,rp)
	local sg1=Duel.GetMatchingGroup(Card.IsDestructable,tp,LOCATION_MZONE,0,nil)
	local sg2=Duel.GetMatchingGroup(Card.IsDestructable,tp,0,LOCATION_MZONE,nil)
	local ct1=Duel.Destroy(sg1,REASON_EFFECT)
	local ct2=Duel.Destroy(sg2,REASON_EFFECT)
	if ct1>0 then
		Duel.BreakEffect()
		Duel.Damage(tp,ct1*300,REASON_EFFECT)
	end
	if ct2>0 then
		Duel.BreakEffect()
		Duel.Damage(1-tp,ct2*300,REASON_EFFECT)
	end
end
