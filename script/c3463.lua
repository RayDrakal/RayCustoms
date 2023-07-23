--地縛開闢
function c3463.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_COUNTER)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_ATTACK_ANNOUNCE)
	e1:SetCondition(c3463.condition)
	e1:SetTarget(c3463.target)
	e1:SetOperation(c3463.activate)
	c:RegisterEffect(e1)
end
function c3463.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetAttacker():IsControler(1-tp) and Duel.GetAttackTarget()==nil and Duel.GetLP(tp)<=6000
end
function c3463.filter(c,tp)
	return c:IsType(TYPE_FIELD) and c:GetActivateEffect():IsActivatable(tp)
end
function c3463.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c3463.filter,tp,LOCATION_DECK,0,1,nil,tp) end
end
function c3463.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetAttacker()
	if tc:IsRelateToBattle() and tc:IsFaceup() and tc:IsAttackable() then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCode(EVENT_PRE_BATTLE_DAMAGE)
		e1:SetValue(1)
		e1:SetOperation(c3463.damop)
		e1:SetReset(RESET_PHASE+PHASE_DAMAGE)
		Duel.RegisterEffect(e1,tp)
		local ftc=Duel.SelectMatchingCard(tp,c3463.filter,tp,LOCATION_DECK,0,1,1,nil,tp):GetFirst()
		if ftc then
			local fc=Duel.GetFieldCard(tp,LOCATION_SZONE,5)
			if fc then
				Duel.SendtoGrave(fc,REASON_RULE)
				Duel.BreakEffect()
			end
			Duel.MoveToField(ftc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
			local te=ftc:GetActivateEffect()
			local tep=ftc:GetControler()
			local cost=te:GetCost()
			if cost then cost(te,tep,eg,ep,ev,re,r,rp,1) end
			Duel.RaiseEvent(ftc,EVENT_CHAIN_SOLVED,te,0,tp,tp,Duel.GetCurrentChain())
		end
	end
end
function c3463.damop(e,tp,eg,ep,ev,re,r,rp)
	local dm=Duel.GetBattleDamage(tp)
	Duel.ChangeBattleDamage(tp,math.ceil(dm/2))
end
