--逆転の明札
function c4096.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_TO_HAND)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_DELAY)
	e1:SetCondition(c4096.condition)
	e1:SetTarget(c4096.target)
	e1:SetOperation(c4096.activate)
	c:RegisterEffect(e1)
end
function c4096.cfilter(c,tp)
	return c:IsControler(tp) and c:IsPreviousLocation(LOCATION_DECK)
end
function c4096.condition(e,tp,eg,ep,ev,re,r,rp)
	local t=Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)
	local s=Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)
	return Duel.GetCurrentPhase()~=PHASE_DRAW and eg:IsExists(c4096.cfilter,1,nil,1-tp)
	and t>s
end
function c4096.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local t=Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)
	local s=Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,t-s) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(t-s)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,t-s)
end
function c4096.activate(e,tp,eg,ep,ev,re,r,rp)
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	local t=Duel.GetFieldGroupCount(p,0,LOCATION_HAND)
	local s=Duel.GetFieldGroupCount(p,LOCATION_HAND,0)
	if t>s then
		Duel.Draw(p,t-s,REASON_EFFECT)
	end
end
