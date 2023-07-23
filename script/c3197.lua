--覇王紫竜オッドアイズ・ヴェノム・ドラゴン
function c3197.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcCode2(c,41209827,16178681,true,true)
	--pendulum summon
	aux.EnablePendulumAttribute(c,false)
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetCode(EFFECT_CHANGE_DAMAGE)
	e0:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e0:SetTargetRange(1,0)
	e0:SetRange(LOCATION_PZONE)
	e0:SetValue(c3197.damval)
	c:RegisterEffect(e0)
	--atk up
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(3197,0))
	e1:SetCategory(CATEGORY_ATKCHANGE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(c3197.atkcon)
	e1:SetTarget(c3197.atktg)
	e1:SetOperation(c3197.atkop)
	c:RegisterEffect(e1)
	--copy
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(3197,1))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCost(c3197.copycost)
	e2:SetTarget(c3197.copytg)
	e2:SetOperation(c3197.copyop)
	c:RegisterEffect(e2)
	--destroy
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(3197,3))
	e3:SetCategory(CATEGORY_DESTROY+CATEGORY_DAMAGE)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e3:SetCode(EVENT_DESTROYED)
	e3:SetTarget(c3197.destg)
	e3:SetOperation(c3197.desop)
	c:RegisterEffect(e3)
end
function c3197.ffilter(c)
	return c:IsAttribute(ATTRIBUTE_DARK)
end
function c3197.atkcon(e,tp,eg,ep,ev,re,r,rp)
	local ct=e:GetHandler():GetMaterial():FilterCount(Card.IsPreviousLocation,nil,LOCATION_MZONE)
	local ct2=e:GetHandler():GetMaterial():GetCount()
	return bit.band(e:GetHandler():GetSummonType(),SUMMON_TYPE_FUSION)==SUMMON_TYPE_FUSION and ct==ct2
end
function c3197.atkfilter(c)
	return c:IsFaceup()
end
function c3197.atktg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c3197.atkfilter,tp,0,LOCATION_MZONE,1,nil) end
end
function c3197.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetMatchingGroup(c3197.atkfilter,tp,0,LOCATION_MZONE,nil)
		if c:IsRelateToEffect(e) and c:IsFaceup() then
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetCode(EFFECT_UPDATE_ATTACK)
			e1:SetValue(tc:GetSum(Card.GetAttack))
			e1:SetReset(RESET_EVENT+0x1ff0000+RESET_PHASE+PHASE_END)
			c:RegisterEffect(e1)
		end
end
function c3197.copycost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():GetFlagEffect(3197)==0 end
	e:GetHandler():RegisterFlagEffect(3197,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1)
end
function c3197.copyfilter(c)
	return c:IsFaceup()
end
function c3197.copytg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(1-tp) and chkc:IsLocation(LOCATION_MZONE) and c3197.copyfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c3197.copyfilter,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c3197.copyfilter,tp,0,LOCATION_MZONE,1,1,nil)
end
function c3197.copyop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc and c:IsRelateToEffect(e) and c:IsFaceup() and tc:IsRelateToEffect(e) and not tc:IsType(TYPE_TOKEN) then
		local code=tc:GetOriginalCode()
		local cid=0
		if not tc:IsType(TYPE_TRAPMONSTER) then
			cid=c:CopyEffect(code,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,1)
		end
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_SINGLE)
		e3:SetCode(EFFECT_DISABLE)
		e3:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e3)
		local e4=Effect.CreateEffect(c)
		e4:SetType(EFFECT_TYPE_SINGLE)
		e4:SetCode(EFFECT_DISABLE_EFFECT)
		e4:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e4)
	end
end
function c3197.desfilter(c)
	return c:IsDestructable()
end
function c3197.penfilter(c,e,tp)
	local seq=c:GetSequence()
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and (seq==6 or seq==7)
end
function c3197.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_SZONE) and chkc:IsControler(tp) and chkc:IsFaceup() end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 
		and Duel.IsExistingTarget(c3197.penfilter,tp,LOCATION_SZONE,0,1,nil,e,tp) end
	local g=Duel.GetMatchingGroup(c3197.desfilter,tp,0,LOCATION_MZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,g:GetSum(Card.GetAttack))
	Duel.SelectTarget(tp,c3197.penfilter,tp,LOCATION_SZONE,0,1,1,nil,e,tp)
end
function c3197.desop(e,tp,eg,ep,ev,re,r,rp)
	local atk=0
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if not c:IsRelateToEffect(e) or Duel.GetLocationCount(tp,LOCATION_MZONE)<1 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	if Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)>0 then
		Duel.MoveToField(c,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
		Duel.BreakEffect()
		local g=Duel.GetMatchingGroup(c3197.desfilter,tp,0,LOCATION_MZONE,nil)
		local tc=g:GetFirst()
		while tc do
			local tatk=tc:GetAttack()
			if Duel.Destroy(tc,REASON_EFFECT)~=0 and tatk>0 and tc:IsFaceup() then atk=atk+tatk end
			tc=g:GetNext()
		end
		Duel.Damage(1-tp,atk,REASON_EFFECT)
	end
end
function c3197.damval(e,re,val,r,rp,rc)
	local tp=e:GetHandlerPlayer()
	if Duel.GetFlagEffect(tp,3197)==0 or bit.band(r,REASON_BATTLE)==0 then return val end
	Duel.ResetFlagEffect(tp,3197)
	return 0
end
