--精霊の鏡
function c4248.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_NEGATE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e1:SetCondition(c4248.condition)
	e1:SetOperation(c4248.activate)
	c:RegisterEffect(e1)
	--remain field
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_REMAIN_FIELD)
	c:RegisterEffect(e3)
end
function c4248.condition(e,tp,eg,ep,ev,re,r,rp)
	return re:IsActiveType(TYPE_SPELL) and re:IsHasType(EFFECT_TYPE_ACTIVATE) and Duel.IsChainNegatable(ev)
end
function c4248.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.NegateActivation(ev) then
		local tc=re:GetHandler()
		--copy
		--old ver
		--local e1=Effect.CreateEffect(c)
		--e1:SetType(EFFECT_TYPE_QUICK_O)
		--e1:SetCode(EVENT_FREE_CHAIN)
		--e1:SetRange(LOCATION_SZONE)
		--e1:SetCountLimit(1)
		--e1:SetLabelObject(re:GetHandler())
		--e1:SetTarget(c4248.stg)
		--e1:SetOperation(c4248.sop)
		--e1:SetReset(RESET_EVENT+0x1fe0000)
		--c:RegisterEffect(e1)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_QUICK_O)
		e1:SetCode(EVENT_FREE_CHAIN)
		e1:SetRange(LOCATION_SZONE)
		e1:SetCountLimit(1)
		e1:SetDescription(aux.Stringid(4248,0))
		e1:SetHintTiming(0x3c0)
		e1:SetLabelObject(re:GetHandler())
		e1:SetTarget(c4248.ctarget)
		e1:SetCost(c4248.ccost)
		e1:SetCondition(c4248.ccondition)
		e1:SetOperation(c4248.cop)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		c:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetDescription(aux.Stringid(4248,1))
		e2:SetType(EFFECT_TYPE_QUICK_O)
		e2:SetRange(LOCATION_SZONE)
		e2:SetCode(EVENT_CHAINING)
		e2:SetLabelObject(re:GetHandler())
		e2:SetCountLimit(1)
		e2:SetCost(c4248.ccost)
		e2:SetTarget(c4248.ctarget2)
		e2:SetOperation(c4248.cop)
		e2:SetReset(RESET_EVENT+0x1fe0000)
		c:RegisterEffect(e2)
	end
end
function c4248.stg(e,tp,eg,ep,ev,re,r,rp,chk)
	local ae=e:GetLabelObject():GetActivateEffect()
	local ftg=ae:GetTarget()
	if chkc then return ftg(e,tp,eg,ep,ev,re,r,rp,chk,chkc) end
	if chk==0 then return not ftg or ftg(e,tp,eg,ep,ev,re,r,rp,chk) end
	if ae:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then
		e:SetProperty(EFFECT_FLAG_CARD_TARGET)
	else e:SetProperty(0) end
	if ftg then
		ftg(e,tp,eg,ep,ev,re,r,rp,chk)
	end
end
function c4248.sop(e,tp,eg,ep,ev,re,r,rp)
	local ae=e:GetLabelObject():GetActivateEffect()
	local fop=ae:GetOperation()
	if fop then fop(e,tp,eg,ep,ev,re,r,rp) end
	Duel.BreakEffect()
	Duel.SendtoGrave(e:GetHandler(),REASON_EFFECT)
end
function c4248.sfilter(c)
	return c:CheckActivateEffect(false,false,false)~=nil
end
function c4248.sfilter2(c,e,tp,eg,ep,ev,re,r,rp)
	local code=c:GetCode()
		if c:CheckActivateEffect(false,false,false)~=nil then return true end
		local te=c:GetActivateEffect()
		if te:GetCode()~=EVENT_CHAINING then return false end
		local con=te:GetCondition()
		if con and not con(e,tp,eg,ep,ev,re,r,rp) then return false end
		local tg=te:GetTarget()
		if tg and not tg(e,tp,eg,ep,ev,re,r,rp,0) then return false end
		return true
end
function c4248.ccondition(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.CheckEvent(EVENT_CHAINING)
end
function c4248.ccost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(1)
	if chk==0 then return e:GetHandler():GetFlagEffect(4248)==0 end
	e:GetHandler():RegisterFlagEffect(4248,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1)
end
function c4248.ctarget(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local g=e:GetLabelObject()
	if chk==0 then
		if e:GetLabel()==0 then return false end
		e:SetLabel(0)
		return g:CheckActivateEffect(false,false,false)~=nil end
	e:SetLabel(0)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local te,ceg,cep,cev,cre,cr,crp=g:CheckActivateEffect(false,true,true)
	e:SetCategory(te:GetCategory())
	e:SetProperty(te:GetProperty())
	local tg=te:GetTarget()
	if tg then tg(e,tp,ceg,cep,cev,cre,cr,crp,1) end
	te:SetLabelObject(e:GetLabelObject())
	e:SetLabelObject(te)
end
function c4248.ctarget2(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=e:GetLabelObject()
	if chk==0 then
		if e:GetLabel()==0 then return false end
		e:SetLabel(0)
		if g:CheckActivateEffect(false,false,false)~=nil then return true end
		local te=g:GetActivateEffect()
		if te:GetCode()~=EVENT_CHAINING then return false end
		local con=te:GetCondition()
		if con and not con(e,tp,eg,ep,ev,re,r,rp) then return false end
		local tg=te:GetTarget()
		if tg and not tg(e,tp,eg,ep,ev,re,r,rp,0) then return false end
	return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local te,ceg,cep,cev,cre,cr,crp
	local fchain=c4248.sfilter(g)
	if fchain then
		te,ceg,cep,cev,cre,cr,crp=g:CheckActivateEffect(false,true,true)
	else
		te=g:GetActivateEffect()
	end
	e:SetCategory(te:GetCategory())
	e:SetProperty(te:GetProperty())
	local tg=te:GetTarget()
	if tg then
		if fchain then
			tg(e,tp,ceg,cep,cev,cre,cr,crp,1)
		else
			tg(e,tp,eg,ep,ev,re,r,rp,1)
		end
	end
	te:SetLabelObject(e:GetLabelObject())
	e:SetLabelObject(te)
end
function c4248.cop(e,tp,eg,ep,ev,re,r,rp)
	local te=e:GetLabelObject()
	if not te then return end
	e:SetLabelObject(te:GetLabelObject())
	local op=te:GetOperation()
	if op then op(e,tp,eg,ep,ev,re,r,rp) end
	Duel.BreakEffect()
	Duel.SendtoGrave(e:GetHandler(),REASON_EFFECT)
end
