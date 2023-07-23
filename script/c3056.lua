--ダークネス3
function c3056.initial_effect(c)
	--Destroy
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(3056,0))
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCategory(CATEGORY_DAMAGE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTarget(c3056.destg)
	e1:SetCondition(c3056.condition)
	e1:SetOperation(c3056.desop)
	c:RegisterEffect(e1)
end
function c3056.condition(e,tp,eg,ep,ev,re,r,rp)
	return false
end
function c3056.dfilter(c)
	return c:IsFaceup() and c:IsCode(3054,3055,3056)
end
function c3056.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	local ct=Duel.GetMatchingGroupCount(c3056.dfilter,tp,LOCATION_SZONE,0,nil)
	Duel.SetTargetPlayer(1-tp)
	Duel.SetTargetParam(1000*ct)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,1000*ct)
end
function c3056.desop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local ct=Duel.GetMatchingGroupCount(c3056.dfilter,tp,LOCATION_SZONE,0,nil)
	if ct==0 then return end
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Damage(p,d,REASON_EFFECT)
end
