--虚無
function c3051.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetTarget(c3051.target)
	e1:SetCondition(c3051.condition)
	e1:SetOperation(c3051.activate)
	c:RegisterEffect(e1)
end
function c3051.filter(c)
	local code=c:GetCode()
	return c:IsFaceup() and (code==3053)
end
function c3051.dfilter(c)
	local code=c:GetCode()
	return c:IsFaceup() and c:IsCode(3054,3055,3056)
end
function c3051.filter(c)
	return c:IsFacedown() and c:GetSequence()~=5
end
function c3051.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_SZONE) end
	if chk==0 then return Duel.IsExistingTarget(c3051.filter,tp,LOCATION_SZONE,0,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEDOWN)
	Duel.SelectTarget(tp,c3051.filter,tp,LOCATION_SZONE,LOCATION_SZONE,1,1,e:GetHandler())
end
function c3051.condition(e)
	return Duel.IsEnvironment(3053)
end
function c3051.activate(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if not tc:IsRelateToEffect(e) or tc:IsFaceup() or not c:IsRelateToEffect(e) then return end
    Duel.ChangePosition(tc,POS_FACEUP)
	local dg=Group.CreateGroup()
	local dtc=tc
	--zero infinity
    if tc:IsCode(3052) then
		local seq1=math.min(c:GetSequence(),tc:GetSequence())
		local seq2=math.max(c:GetSequence(),tc:GetSequence())
		local seqsum=seq2-seq1-1
		if seqsum==0 then return end
		for i=seq1+1,seq2-1 do
			local card=Duel.GetFieldCard(c:GetControler(),LOCATION_SZONE,i)
			if card then
				Duel.ChangePosition(card,POS_FACEUP)
				dg:AddCard(card)
			end
		end
		if dg:GetCount()==0 then return end
	else
		dg:AddCard(tc)
    end
    dtc=dg:GetFirst()
    while dtc do
		local tpe=dtc:GetType()
		local te=dtc:GetActivateEffect()
		local tep=dtc:GetControler()
		local tg=te:GetTarget()
		local co=te:GetCost()
		local op=te:GetOperation()
		local con=te:GetCondition()
		if (te:GetCode()==EVENT_FREE_CHAIN and (not con or con(te,tep,eg,ep,ev,re,r,rp))
			and (not tg or tg(te,tep,eg,ep,ev,re,r,rp,0))) or dtc:IsCode(3054,3055,3056) then
			dtc:CreateEffectRelation(te)
			if co then co(te,tp,eg,ep,ev,re,r,rp,1) end
			if tg then tg(te,tp,eg,ep,ev,re,r,rp,1) end
			local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
			local etc=g:GetFirst()
			while etc do
				etc:CreateEffectRelation(te)
				etc=g:GetNext()
			end
			Duel.Hint(HINT_CARD,0,dtc:GetOriginalCode())
			if op then op(te,tp,eg,ep,ev,re,r,rp) end
			dtc:ReleaseEffectRelation(te)
			etc=g:GetFirst()
			while etc do
				etc:ReleaseEffectRelation(te)
				etc=g:GetNext()
			end
		end
		if bit.band(tpe,TYPE_EQUIP+TYPE_CONTINUOUS)==0 and bit.band(tpe,TYPE_FIELD)==0 and not dtc:IsHasEffect(EFFECT_REMAIN_FIELD) then
			Duel.SendtoGrave(dtc,nil,REASON_RULE)
		else
			dtc:CancelToGrave(true)
		end
	dtc=dg:GetNext()
	end
end
