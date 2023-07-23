--覇王乱舞
function c2811.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(2811,0))
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_BATTLE_START+TIMING_BATTLE_END)
	e1:SetTarget(c2811.target1)
	e1:SetOperation(c2811.operation)
	c:RegisterEffect(e1)
	--must attack
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(2811,1))
	e2:SetCategory(CATEGORY_TOGRAVE+CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetHintTiming(0,TIMING_BATTLE_START+TIMING_BATTLE_END)
	e2:SetCondition(c2811.condition)
	e2:SetCost(c2811.cost)
	e2:SetTarget(c2811.target2)
	e2:SetOperation(c2811.operation)
	e2:SetLabel(1)
	c:RegisterEffect(e2)
	--battle
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(2811,4))
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_PRE_DAMAGE_CALCULATE)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCondition(c2811.bcon)
	e3:SetCost(c2811.ccost)
	e3:SetOperation(c2811.bop)
	c:RegisterEffect(e3)
	--effect
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(2811,5))
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_CHAINING)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCondition(c2811.econ)
	e4:SetCost(c2811.ccost)
	e4:SetTarget(c2811.etg)
	e4:SetOperation(c2811.eop)
	c:RegisterEffect(e4)
	--Activate(battle)
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(2811,4))
	e5:SetType(EFFECT_TYPE_ACTIVATE)
	e5:SetCode(EVENT_PRE_DAMAGE_CALCULATE)
	e5:SetCondition(c2811.bcon)
	e5:SetCost(c2811.ccost)
	e5:SetOperation(c2811.bop)
	c:RegisterEffect(e5)
	--Activate(effect)
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(2811,5))
	e6:SetType(EFFECT_TYPE_ACTIVATE)
	e6:SetCode(EVENT_CHAINING)
	e6:SetCondition(c2811.econ)
	e6:SetCost(c2811.ccost)
	e6:SetTarget(c2811.etg)
	e6:SetOperation(c2811.eop)
	c:RegisterEffect(e6)
	--must attack2
	local e7=Effect.CreateEffect(c)
	e7:SetDescription(aux.Stringid(2811,6))
	e7:SetHintTiming(0,TIMING_BATTLE_START+TIMING_BATTLE_END)
	e7:SetType(EFFECT_TYPE_QUICK_O)
	e7:SetCode(EVENT_FREE_CHAIN)
	e7:SetRange(LOCATION_SZONE)
	e7:SetCost(c2811.macost)
	e7:SetCondition(c2811.macon)
	e7:SetOperation(c2811.maop)
	c:RegisterEffect(e7)
	--battle check
	if not c2811.global_check then
		c2811.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_BATTLE_START)
		ge1:SetOperation(c2811.check)
		Duel.RegisterEffect(ge1,0)
	end
end
function c2811.mafilter(c)
	return c:IsPosition(POS_FACEUP_ATTACK)
end
function c2811.cfilter(c)
	return c:IsFaceup() and (c:IsSetCard(507) or c:IsSetCard(0x20f8) or c:IsSetCard(0x11fb))
end
function c2811.target1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and  chkc:IsControler(1-tp) and c2811.mafilter(chkc) end
	if chk==0 then return true end
	local tn=Duel.GetTurnPlayer()
	local ph=Duel.GetCurrentPhase()
	if tn~=tp and (ph>=PHASE_BATTLE_START and ph<=PHASE_BATTLE) and Duel.IsExistingTarget(c2811.mafilter,tp,0,LOCATION_MZONE,1,nil)
		and e:GetHandler():GetFlagEffect(2811001)==0 and Duel.SelectYesNo(tp,94) then
		e:SetProperty(EFFECT_FLAG_CARD_TARGET)
		local g=Duel.SelectTarget(tp,c2811.mafilter,tp,0,LOCATION_MZONE,1,1,nil)
		e:SetLabel(1)
		e:GetHandler():RegisterFlagEffect(2811001,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1,1)
	else
		e:SetCategory(0)
		e:SetProperty(0)
		e:SetLabel(0)
	end
end
function c2811.target2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and  chkc:IsControler(1-tp) and c2811.mafilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c2811.mafilter,tp,0,LOCATION_MZONE,1,nil) end
	local g=Duel.SelectTarget(tp,c2811.mafilter,tp,0,LOCATION_MZONE,1,1,nil)
end
function c2811.condition(e,tp,eg,ep,ev,re,r,rp)
	local tn=Duel.GetTurnPlayer()
	local ph=Duel.GetCurrentPhase()
	return Duel.IsExistingMatchingCard(c2811.cfilter,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil)
	and tn~=tp and (ph>=PHASE_BATTLE_START and ph<=PHASE_BATTLE)
	and e:GetHandler():GetFlagEffect(2811001)==0
end
function c2811.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	e:GetHandler():RegisterFlagEffect(2811001,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1,1)
end
function c2811.operation(e,tp,eg,ep,ev,re,r,rp)
	if e:GetLabel()==0 or not e:GetHandler():IsRelateToEffect(e) then return end
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_MUST_ATTACK)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_BATTLE)
		tc:RegisterEffect(e1)
		if tc:GetFlagEffectLabel(2811)~=0 then
				local e1=Effect.CreateEffect(c)
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_EXTRA_ATTACK)
				e1:SetValue(tc:GetFlagEffectLabel(2811))
				e1:SetReset(RESET_EVENT+0x1ff0000+RESET_PHASE+PHASE_BATTLE)
				tc:RegisterEffect(e1)
		end
	end
end
function c2811.check(e,tp,eg,ep,ev,re,r,rp)
	local bc=Duel.GetAttackTarget()
	if not bc then return end
	local tc=Duel.GetAttacker()
	local ct=tc:GetFlagEffectLabel(2811)
	local ct2=bc:GetFlagEffectLabel(2811)
	if ct then
		tc:SetFlagEffectLabel(2811,ct+1)
	else
		tc:RegisterFlagEffect(2811,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1,1)
	end
	if ct2 then
		bc:SetFlagEffectLabel(2811,ct2+1)
	else
		bc:RegisterFlagEffect(2811,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1,1)
	end
end
function c2811.bcon(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetAttacker()
	local c=e:GetHandler()
	if tc:IsControler(1-tp) then tc=Duel.GetAttackTarget() end
	return tc and c:IsSetCard(0xf8) and tc:IsRelateToBattle()
	and c:GetFlagEffect(2811002)==0
end
function c2811.ccost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	e:GetHandler():RegisterFlagEffect(2811002,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1,1)
end
function c2811.bop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetAttacker()
	if tc:IsControler(1-tp) then tc=Duel.GetAttackTarget() end
	if not tc or not tc:IsRelateToBattle() or not e:GetHandler():IsRelateToEffect(e) then return end
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e1:SetValue(1)
	e1:SetReset(RESET_PHASE+PHASE_DAMAGE)
	tc:RegisterEffect(e1)
end
function c2811.btg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and  chkc:IsControler(1-tp) and c2811.mafilter(chkc) end
	if chk==0 then return true end
	local tn=Duel.GetTurnPlayer()
	local ph=Duel.GetCurrentPhase()
	if tn~=tp and (ph>=PHASE_BATTLE_START and ph<=PHASE_BATTLE) and Duel.IsExistingTarget(c2811.mafilter,tp,0,LOCATION_MZONE,1,nil)
		and e:GetHandler():GetFlagEffect(2811002)==0 and Duel.SelectYesNo(tp,94) then
		e:SetProperty(EFFECT_FLAG_CARD_TARGET)
		local g=Duel.SelectTarget(tp,c2811.mafilter,tp,0,LOCATION_MZONE,1,1,nil)
		e:SetLabel(1)
	else
		e:SetCategory(0)
		e:SetProperty(0)
		e:SetLabel(0)
	end
end
function c2811.bop2(e,tp,eg,ep,ev,re,r,rp)
	if e:GetLabel()==0 or not e:GetHandler():IsRelateToEffect(e) then return end
	local tc=Duel.GetAttacker()
	if tc:IsControler(1-tp) then tc=Duel.GetAttackTarget() end
	if not tc or not tc:IsRelateToBattle() then return end
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e1:SetValue(1)
	e1:SetReset(RESET_PHASE+PHASE_DAMAGE)
	tc:RegisterEffect(e1)
end
function c2811.efilter(c,p)
	return c:IsOnField() and c:IsSetCard(0x20f8)
end
function c2811.econ(e,tp,eg,ep,ev,re,r,rp)
	local ex,tg,tc=Duel.GetOperationInfo(ev,CATEGORY_DESTROY)
	return ex and tg~=nil and tc+tg:FilterCount(c2811.efilter,nil,tp)-tg:GetCount()>0
	and e:GetHandler():GetFlagEffect(2811002)==0
end
function c2811.valcon(e,re,r,rp)
	return bit.band(r,REASON_EFFECT)~=0
end
function c2811.etg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local ex,tg,tc=Duel.GetOperationInfo(ev,CATEGORY_DESTROY)
	local reg=tg:Filter(c2811.efilter,e:GetHandler(),tp)
	local tc=reg:GetFirst()
	while tc do
		tc:RegisterFlagEffect(2811,RESET_EVENT+0x1fe0000+RESET_CHAIN,0,1)
		tc=reg:GetNext()
	end
end
function c2811.epfilter(c)
	return c:GetFlagEffect(2811)~=0
end
function c2811.eop(e,tp,eg,ep,ev,re,r,rp)
	local ex,tg,tc=Duel.GetOperationInfo(ev,CATEGORY_DESTROY)
	local g=Duel.GetMatchingGroup(c2811.epfilter,tp,LOCATION_ONFIELD,0,nil)
	local c=e:GetHandler()
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local tc2=g:GetFirst()
	while tc2 do
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_INDESTRUCTABLE_COUNT)
		e1:SetRange(LOCATION_MZONE)
		e1:SetValue(c2811.valcon)
		e1:SetCountLimit(1)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		tc2:RegisterEffect(e1)
		tc2=g:GetNext()
	end
end
function c2811.macost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToGraveAsCost() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST)
end
function c2811.macon(e,tp,eg,ep,ev,re,r,rp)
	local tn=Duel.GetTurnPlayer()
	local ph=Duel.GetCurrentPhase()
	return tn~=tp and (ph>=PHASE_BATTLE_START and ph<=PHASE_BATTLE)
end
function c2811.maop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_PATRICIAN_OF_DARKNESS)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(0,1)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_MUST_ATTACK)
	e2:SetTargetRange(0,LOCATION_MZONE)
	e2:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e2,tp)
end
