--アフター・グロー 
function c4070.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TODECK+CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetOperation(c4070.activate)
	c:RegisterEffect(e1)
end
function c4070.rfilter(c)
	return c:IsAbleToRemove() and c:IsCode(4070)
end
function c4070.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
		local sd=Duel.GetMatchingGroup(c4070.rfilter,tp,LOCATION_DECK,0,nil)
		Duel.Remove(sd,POS_FACEUP,REASON_EFFECT)
	if c:IsRelateToEffect(e) then
		c:CancelToGrave()
		Duel.SendtoDeck(c,nil,2,REASON_EFFECT)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetProperty(EFFECT_FLAG_DELAY)
		e1:SetCode(EVENT_DRAW)
		e1:SetCountLimit(1)
		e1:SetCondition(c4070.con)
		e1:SetOperation(c4070.op)
		if Duel.GetTurnPlayer()==tp and Duel.GetCurrentPhase()==PHASE_DRAW then
			e1:SetLabel(Duel.GetTurnCount())
			e1:SetReset(RESET_PHASE+PHASE_DRAW+RESET_SELF_TURN,2)
		else
			e1:SetLabel(0)
			e1:SetReset(RESET_PHASE+PHASE_DRAW+RESET_SELF_TURN)
		end
		Duel.RegisterEffect(e1,tp)
	end
end
function c4070.con(e,tp,eg,ep,ev,re,r,rp)
	return ep==tp and bit.band(r,REASON_RULE)~=0 and Duel.GetTurnPlayer()==tp and Duel.GetTurnCount()~=e:GetLabel() 
		and Duel.GetCurrentPhase()==PHASE_DRAW
end
function c4070.op(e,tp,eg,ep,ev,re,r,rp)
	local g=eg:Filter(Card.IsControler,nil,tp)
	if g:GetCount()<=0 then return end
	Duel.Hint(HINT_CARD,0,4070)
	Duel.ConfirmCards(1-tp,g)
	if eg:IsExists(Card.IsCode,1,nil,4070) then
		Duel.Damage(1-tp,8000,REASON_EFFECT)
	end
	Duel.ShuffleHand(tp)
end
