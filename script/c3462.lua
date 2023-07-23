--地縛魔封
function c3462.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCondition(c3462.condition)
	e1:SetTarget(c3462.target)
	e1:SetOperation(c3462.activate)
	c:RegisterEffect(e1)
end
function c3462.condition(e,tp,eg,ep,ev,re,r,rp)
	local f1=Duel.GetFieldCard(tp,LOCATION_SZONE,5)
	return re:IsActiveType(TYPE_SPELL) and re:IsHasType(EFFECT_TYPE_ACTIVATE) and Duel.IsChainNegatable(ev)
		and not (f1==nil or not f1:IsFaceup()) and ep~=tp 
end
function c3462.cfilter(c)
	return c:IsType(TYPE_SPELL) and c:IsDiscardable()
end
function c3462.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function c3462.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
		Duel.Destroy(eg,REASON_EFFECT)
	end
end
