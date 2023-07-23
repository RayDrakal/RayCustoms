--ミラーナイト・コーリング
function c3109.initial_effect(c)
	c:EnableReviveLimit()
	--Special Summon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetTarget(c3109.target)
	e1:SetOperation(c3109.operation)
	c:RegisterEffect(e1)
	--Mirror
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EVENT_ADJUST)
	e2:SetOperation(c3109.renop)
	c:RegisterEffect(e2)
end
function c3109.ctop1(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():AddCounter(COUNTER_NEED_ENABLE+0x1342,1)
end
function c3109.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,4,tp,0)
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,4,tp,0)
end
function c3109.operation(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<4 then return end
	if not Duel.IsPlayerCanSpecialSummonMonster(tp,3110,0,0x4011,0,0,1,RACE_WARRIOR,ATTRIBUTE_DARK) then return end
	for i=1,4 do
		local token=Duel.CreateToken(tp,3110)
		Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP_ATTACK)
		token:AddCounter(0x1342,1)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EFFECT_DESTROY_REPLACE)
		e1:SetRange(LOCATION_MZONE)
		e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e1:SetTarget(c3109.reptg)
		e1:SetOperation(c3109.repop)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		token:RegisterEffect(e1)
		--attack copy
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_SET_ATTACK_FINAL)
		e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_REPEAT+EFFECT_FLAG_DELAY)
		e2:SetRange(LOCATION_MZONE)
		e2:SetValue(c3109.atkop)
		e2:SetCondition(c3109.atkcon)
		token:RegisterEffect(e2)
		----immune
		--local e3=Effect.CreateEffect(e:GetHandler())
		--e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
		--e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
		--e3:SetCode(EVENT_BATTLE_START)
		--e3:SetCondition(c3109.btcon)
		--e3:SetOperation(c3109.btop)
		--token:RegisterEffect(e3)  
	end
	Duel.SpecialSummonComplete()
end
function c3109.atkcon(e)
	local ph=Duel.GetCurrentPhase()
	if not (Duel.GetCurrentPhase()>=PHASE_BATTLE_START and Duel.GetCurrentPhase()<=PHASE_BATTLE) then return false end
	local a=Duel.GetAttacker()
	local d=Duel.GetAttackTarget()
	return e:GetHandler():GetCounter(0x1342)>0 and( (a==e:GetHandler() and d and d:IsFaceup())
		or (d==e:GetHandler()))
end
function c3109.atkop(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetBattleTarget():GetAttack()
end
function c3109.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():GetCounter(0x1342)>0 end
	return true
end
function c3109.repop(e,tp,eg,ep,ev,re,r,rp,chk)
	e:GetHandler():RemoveCounter(tp,0x1342,1,REASON_EFFECT)
end
function c3109.renop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsCode,tp,LOCATION_MZONE,0,nil,3110)
	local tc=g:GetFirst()
	while tc do
        if tc:GetCounter(0x1342)==0 then
		tc:AddCounter(0x1342,1)
        end
		tc=g:GetNext()
	end
end
function c3109.mefilter(e,te)
	return te:GetOwner():IsCode(3100)
end
function c3109.btcon(e)
	local c=e:GetHandler()
	local bc=c:GetBattleTarget()
	return c:IsRelateToBattle() and bc and bc:IsRelateToBattle()
end
function c3109.btop(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetValue(c3109.mefilter)
	e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_DAMAGE)
	e:GetHandler():RegisterEffect(e1)
end
