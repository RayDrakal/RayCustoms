--EM五虹の魔術師
function c3195.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--atk 2
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetProperty(EFFECT_FLAG_BOTH_SIDE)
	e1:SetCountLimit(1)
	e1:SetCondition(c3195.mcon)
	e1:SetOperation(c3195.mop)
	c:RegisterEffect(e1)
	--action card
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(4300)
	e2:SetRange(LOCATION_PZONE)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetTargetRange(1,1)
	c:RegisterEffect(e2)
	--end turn
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(EVENT_SSET)
	e3:SetRange(LOCATION_PZONE)
	e3:SetOperation(c3195.etop)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	--hand set
	local e5=Effect.CreateEffect(c)
	e5:SetCategory(CATEGORY_DESTROY)
	e5:SetType(EFFECT_TYPE_QUICK_O)
	e5:SetCode(EVENT_TO_HAND)
	e5:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY+EFFECT_FLAG_BOTH_SIDE)
	e5:SetRange(LOCATION_PZONE)
	e5:SetCost(c3195.handcost)
	e5:SetCondition(c3195.handcon)
	e5:SetTarget(c3195.handtg)
	e5:SetOperation(c3195.handop)
	c:RegisterEffect(e5)
	--skip turn
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e6:SetCode(EVENT_PREDRAW)
	e6:SetRange(LOCATION_PZONE)
	e6:SetCondition(c3195.thcon)
	e6:SetOperation(c3195.thop)
	c:RegisterEffect(e6)
	--atk 0
	local e7=Effect.CreateEffect(c)
	e7:SetDescription(aux.Stringid(3195,1))
	e7:SetProperty(EFFECT_FLAG_BOTH_SIDE)
	e7:SetType(EFFECT_TYPE_IGNITION)
	e7:SetRange(LOCATION_PZONE)
	e7:SetCountLimit(1)
	e7:SetCondition(c3195.acon)
	e7:SetOperation(c3195.aop)
	c:RegisterEffect(e7)
	-- atk 2
	local e8=Effect.CreateEffect(c)
	e8:SetDescription(aux.Stringid(3195,2))
	e8:SetProperty(EFFECT_FLAG_BOTH_SIDE)
	e8:SetType(EFFECT_TYPE_IGNITION)
	e8:SetRange(LOCATION_PZONE)
	e8:SetCondition(c3195.acon2)
	e8:SetOperation(c3195.aop2)
	c:RegisterEffect(e8)
end
function c3195.etop(e,tp,eg,ep,ev,re,r,rp)
	Duel.SkipPhase(Duel.GetTurnPlayer(),PHASE_DRAW,RESET_PHASE+PHASE_END,1)
	Duel.SkipPhase(Duel.GetTurnPlayer(),PHASE_STANDBY,RESET_PHASE+PHASE_END,1)
	Duel.SkipPhase(Duel.GetTurnPlayer(),PHASE_MAIN1,RESET_PHASE+PHASE_END,1)
	Duel.SkipPhase(Duel.GetTurnPlayer(),PHASE_BATTLE,RESET_PHASE+PHASE_END,1,1)
	Duel.SkipPhase(Duel.GetTurnPlayer(),PHASE_MAIN2,RESET_PHASE+PHASE_END,1)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_BP)
	e1:SetTargetRange(1,1)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c3195.handfilter(c,tp)
	return not c:IsPreviousLocation(LOCATION_HAND) and c:IsSSetable() and c:IsControler(tp) 
end
function c3195.handcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not Duel.IsPlayerAffectedByEffect(tp,3195) end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(3195)
	e1:SetTargetRange(1,0)
	e1:SetReset(RESET_CHAIN)
	Duel.RegisterEffect(e1,tp)
end
function c3195.handcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()~=PHASE_DRAW and eg:IsExists(c3195.handfilter,1,nil,tp)
end
function c3195.handtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetCard(eg)
end
function c3195.handop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local g=eg:Filter(c3195.handfilter,nil,tp):Filter(Card.IsRelateToEffect,nil,e)
	if g:GetCount()>0 then
		local tc=g:GetFirst()
		while tc do
			Duel.SSet(tc:GetControler(),tc)
			tc=g:GetNext()
		end
	end
end
function c3195.thcon(e,tp,eg,ep,ev,re,r,rp)
	local tp=Duel.GetTurnPlayer()
	return Duel.GetDrawCount(tp)>0 and not Duel.IsExistingMatchingCard(Card.IsFacedown,tp,LOCATION_SZONE,0,5,nil)
end
function c3195.thop(e,tp,eg,ep,ev,re,r,rp)
	local dt=Duel.GetDrawCount(tp)
	if dt~=0 then
		if Duel.SelectYesNo(Duel.GetTurnPlayer(),aux.Stringid(3195,0)) then
			_replace_count=0
			_replace_max=dt
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_FIELD)
			e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
			e1:SetCode(EFFECT_DRAW_COUNT)
			e1:SetTargetRange(1,1)
			e1:SetReset(RESET_PHASE+PHASE_DRAW)
			e1:SetValue(0)
			Duel.RegisterEffect(e1,tp)
		else
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_FIELD)
			e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
			e1:SetCode(EFFECT_CANNOT_SSET)
			e1:SetTargetRange(1,0)
			e1:SetReset(RESET_PHASE+PHASE_END)
			Duel.RegisterEffect(e1,Duel.GetTurnPlayer())
		end
	end
end
function c3195.dt(e,c)
	return c:IsFaceup()
end
function c3195.actlimit(e,re,rp)
	local rc=re:GetHandler()
	return re:IsActiveType(TYPE_MONSTER) and not rc:IsImmuneToEffect(e)
end
function c3195.acon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetFlagEffect(3195)==0
end
function c3195.acon4(e,tp,eg,ep,ev,re,r,rp)
	local count=Duel.GetFieldGroupCount(tp,LOCATION_SZONE,0)
	return not Duel.IsExistingMatchingCard(Card.IsFacedown,tp,LOCATION_SZONE,0,5,nil)
end
function c3195.acon42(e,tp,eg,ep,ev,re,r,rp)
	local count=Duel.GetFieldGroupCount(tp,0,LOCATION_SZONE)
	return not Duel.IsExistingMatchingCard(Card.IsFacedown,tp,0,LOCATION_SZONE,5,nil)
end
function c3195.aop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	--atk
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetRange(LOCATION_PZONE)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetCode(EFFECT_SET_ATTACK)
	e1:SetCondition(c3195.acon4)
	e1:SetValue(0)
	e1:SetReset(RESET_EVENT+0x1fe0000)
	c:RegisterEffect(e1)
	--can not attack
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_PZONE)
	e2:SetCode(EFFECT_CANNOT_ATTACK)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetTarget(c3195.dt)
	e2:SetCondition(c3195.acon4)
	e2:SetReset(RESET_EVENT+0x1fe0000)
	c:RegisterEffect(e2)
	--can not activate
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_CANNOT_ACTIVATE)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetTargetRange(1,0)
	e3:SetValue(c3195.actlimit)
	e3:SetCondition(c3195.acon4)
	e3:SetReset(RESET_EVENT+0x1fe0000)
	c:RegisterEffect(e3)
	--atk
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetRange(LOCATION_PZONE)
	e4:SetTargetRange(0,LOCATION_MZONE)
	e4:SetCode(EFFECT_SET_ATTACK_FINAL)
	e4:SetCondition(c3195.acon42)
	e4:SetValue(0)
	e4:SetReset(RESET_EVENT+0x1fe0000)
	c:RegisterEffect(e4)
	--can not attack
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetRange(LOCATION_PZONE)
	e5:SetCode(EFFECT_CANNOT_ATTACK)
	e5:SetTargetRange(0,LOCATION_MZONE)
	e5:SetTarget(c3195.dt)
	e5:SetCondition(c3195.acon42)
	e5:SetReset(RESET_EVENT+0x1fe0000)
	c:RegisterEffect(e5)
	--can not activate
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_FIELD)
	e6:SetCode(EFFECT_CANNOT_ACTIVATE)
	e6:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e6:SetTargetRange(0,1)
	e6:SetValue(c3195.actlimit)
	e6:SetCondition(c3195.acon42)
	e6:SetReset(RESET_EVENT+0x1fe0000)
	c:RegisterEffect(e6)
	c:RegisterFlagEffect(3195,RESET_EVENT+0x1fe0000,0,1)
end
function c3195.acon2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(Card.IsFacedown,tp,LOCATION_SZONE,0,5,nil)
end
function c3195.filter2(c,e)
	return c:IsFaceup()
end
function c3195.aop2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local sg=Duel.GetMatchingGroup(c3195.filter2,tp,LOCATION_MZONE,0,nil)
	local tc=sg:GetFirst()
	while tc do
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_ATTACK_FINAL)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		e1:SetValue(tc:GetTextAttack()*2)
		tc:RegisterEffect(e1)
		tc=sg:GetNext()
	end
end
function c3195.mfilter(c,e)
	return c:IsFaceup() and c:IsType(TYPE_PENDULUM)
end
function c3195.mcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c3195.mfilter,tp,LOCATION_MZONE,0,5,nil)
end
function c3195.mop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local sg=Duel.GetMatchingGroup(c3195.mfilter,tp,LOCATION_MZONE,0,nil,e)
	local tc=sg:GetFirst()
	while tc do
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_ATTACK_FINAL)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		e1:SetValue(tc:GetTextAttack()*2)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_CANNOT_DIRECT_ATTACK)
		e2:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e2)
		tc=sg:GetNext()
	end
end
