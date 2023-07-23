--エクシーズ・トレジャー
function c3230.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(c3230.condition)
	e1:SetTarget(c3230.target)
	e1:SetOperation(c3230.activate)
	c:RegisterEffect(e1)
end
function c3230.cfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_XYZ)
end
function c3230.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c3230.cfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil)
end
function c3230.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,2) end
	local g=Duel.GetMatchingGroupCount(c3230.cfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(g)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,g)
end
function c3230.activate(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end
