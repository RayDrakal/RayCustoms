--
function c3383.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--attack up
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_ATKCHANGE)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_CHANGE_POS)
	e2:SetRange(LOCATION_FZONE)
	e2:SetCondition(c3383.rdcon)
	e2:SetOperation(c3383.rdop)
	c:RegisterEffect(e2)
	--to deck
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_TODECK)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e3:SetCountLimit(1)
	e3:SetRange(LOCATION_FZONE)
	e3:SetCondition(c3383.tdcon)
	e3:SetTarget(c3383.tdtg)
	e3:SetOperation(c3383.tdop)
	c:RegisterEffect(e3)
end
function c3383.rdop(e,tp,eg,ep,ev,re,r,rp)
	Duel.ChangeBattleDamage(ep,ev*2)
end
function c3383.tdcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp and Duel.GetFlagEffect(tp,3380)==0
end
function c3383.tdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,e:GetHandler(),1,0,0)
end
function c3383.tdfilter(c)
	return c:IsCode(3380)
end
function c3383.tdop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.SendtoDeck(c,nil,2,REASON_EFFECT) then
	local g=Duel.SelectMatchingCard(tp,c3383.tdfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
	local tc=g:GetFirst()
	Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true) 
	Duel.RegisterFlagEffect(tp,3380,RESET_PHASE+PHASE_END,0,1)
	local te=tc:GetActivateEffect()
	Duel.RaiseEvent(tc,EVENT_CHAIN_SOLVED,te,0,tp,tp,Duel.GetCurrentChain())
	end
	end
end
function c3383.cfilter(c,tp)
	local np=c:GetPosition()
	local pp=c:GetPreviousPosition()
	return not c:IsStatus(STATUS_CONTINUOUS_POS) and (np<3 and pp>3)
end
function c3383.rdcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c3383.cfilter,1,nil,tp)
end
function c3383.rdop(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	if tc then
	local c=e:GetHandler()
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_ATTACK_FINAL)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		e1:SetValue(tc:GetAttack()*2)
		tc:RegisterEffect(e1)
	end
end
