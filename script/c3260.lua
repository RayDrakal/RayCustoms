--命削りの宝札
function c3260.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c3260.target)
	e1:SetOperation(c3260.activate)
	e1:SetCondition(c3260.condition)
	c:RegisterEffect(e1)
end
function c3260.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local ht=Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)
	if chk==0 then return (ht<6 and Duel.IsPlayerCanDraw(tp,5-ht)) end
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,1-tp,5-ht)
end
function c3260.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Group.CreateGroup()
	local ht1=Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)
	if ht1<5 then
		Duel.Draw(tp,5-ht1,REASON_EFFECT)
		c:SetTurnCounter(0)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_PHASE+PHASE_STANDBY)
		e1:SetRange(LOCATION_GRAVE)
		e1:SetCountLimit(1)
		e1:SetCondition(c3260.discon)
		e1:SetOperation(c3260.disop)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_STANDBY+RESET_SELF_TURN,5)
		Duel.RegisterEffect(e1,tp)
	end
end
function c3260.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)<6
end
function c3260.discon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end
function c3260.disop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ct=c:GetTurnCounter()
	ct=ct+1
	c:SetTurnCounter(ct)
	if ct==5 then
		local g=Duel.GetFieldGroup(e:GetOwnerPlayer(),LOCATION_HAND,0)
		Duel.SendtoGrave(g,REASON_EFFECT+REASON_DISCARD)
	end
end
