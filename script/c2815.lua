--エン・フラワーズ
function c2815.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--destroy
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DESTROY+CATEGORY_DAMAGE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1)
	e2:SetHintTiming(0,0x1e0)
	e2:SetCondition(c2815.descon)
	e2:SetTarget(c2815.destg)
	e2:SetOperation(c2815.desop)
	c:RegisterEffect(e2)
end
function c2815.enfilter(c)
	return c:IsFaceup() and c:IsCode(2816,2817,2818)
end
function c2815.descon(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c2815.enfilter,tp,LOCATION_SZONE,0,e:GetHandler())
	return g:GetClassCount(Card.GetCode)>=3
end
function c2815.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(Card.IsDestructable,tp,LOCATION_MZONE,LOCATION_MZONE,e:GetHandler())
	if chk==0 then return g:GetCount()>0 end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c2815.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local sg=Duel.GetMatchingGroup(Card.IsDestructable,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	if sg:GetCount()==0 then return end
	local tc=sg:GetFirst()
	while tc do
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e2)
		if tc:IsType(TYPE_TRAPMONSTER) then
			local e3=Effect.CreateEffect(c)
			e3:SetType(EFFECT_TYPE_SINGLE)
			e3:SetCode(EFFECT_DISABLE_TRAPMONSTER)
			e3:SetReset(RESET_EVENT+0x1fe0000)
			tc:RegisterEffect(e3)
		end
		Duel.AdjustInstantly()
		Duel.NegateRelatedChain(tc,RESET_TURN_SET)
		tc=sg:GetNext()
	end
	local g1=sg:Filter(Card.IsControler,nil,tp)
	local g2=sg:Filter(Card.IsControler,nil,1-tp)
	local ct1=Duel.Destroy(g1,REASON_EFFECT)
	local ct2=Duel.Destroy(g2,REASON_EFFECT)
	if ct1>0 or ct2>0 then
		Duel.Damage(tp,ct1*600,REASON_EFFECT)
		Duel.Damage(1-tp,ct2*600,REASON_EFFECT)
	end
	
end
