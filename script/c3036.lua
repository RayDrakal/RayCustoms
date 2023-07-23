--Ｓｉｎ Ｔｕｎｅ
function c3036.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_BATTLE_DESTROYED)
	e1:SetCondition(c3036.condition)
	e1:SetTarget(c3036.target)
	e1:SetOperation(c3036.activate)
	c:RegisterEffect(e1)
end
function c3036.cfilter(c,tp)
	return c:IsSetCard(0x23)
end
function c3036.condition(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c3036.cfilter,1,nil,tp)
end
function c3036.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,2) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(2)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,2)
end
function c3036.activate(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end
