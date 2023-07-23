--マジカル・ペンデュラム・ボックス
function c3182.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c3182.target)
	e1:SetOperation(c3182.activate)
	c:RegisterEffect(e1)
end
function c3182.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,2) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(2)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,2)
end
function c3182.filter(c)
	return not c:IsType(TYPE_PENDULUM)
end
function c3182.activate(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	if Duel.Draw(p,d,REASON_EFFECT)~=0 then
	local g=Duel.GetOperatedGroup()
	Duel.ConfirmCards(1-tp,g)
	local dg=g:Filter(c3182.filter,nil,e,tp)
	Duel.SendtoGrave(dg,REASON_EFFECT)
	Duel.ShuffleHand(tp)
	end
end
