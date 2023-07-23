--ヌメロン・リライティング・マジック
function c4014.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DISABLE+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCondition(c4014.condition)
	e1:SetTarget(c4014.target)
	e1:SetOperation(c4014.activate)
	c:RegisterEffect(e1)
end
function c4014.cfilter(c)
	return c:GetSequence()<5
end
function c4014.condition(e,tp,eg,ep,ev,re,r,rp)
	return re:IsActiveType(TYPE_SPELL) and re:IsHasType(EFFECT_TYPE_ACTIVATE) and Duel.IsChainNegatable(ev)
	and not Duel.IsExistingMatchingCard(c4014.cfilter,tp,LOCATION_SZONE,0,1,e:GetHandler())
	and not Duel.IsExistingMatchingCard(nil,tp,LOCATION_MZONE,0,1,nil)
	and Duel.IsExistingMatchingCard(nil,tp,0,LOCATION_DECK,1,nil,e,tp)
end

function c4014.sfilter(c,e,tp,eg,ep,ev,re,r,rp)
	local te=c:GetActivateEffect()
	if not te then return false end
	local condition=te:GetCondition()
	local cost=te:GetCost()
	local target=te:GetTarget()
	if c:IsType(TYPE_SPELL) and te then
		if c:IsSetCard(0x95) then
			local tg=te:GetTarget()
			return not tg or tg(e,tp,eg,ep,ev,re,r,rp,0)
		else
			return (not condition or condition(te,1-tp,eg,ep,ev,re,r,rp)) and (not cost or cost(te,1-tp,eg,ep,ev,re,r,rp,0)) and (not target or target(te,1-tp,eg,ep,ev,re,r,rp,0))
		end
	end
	return false
end
function c4014.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function c4014.activate(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.NegateActivation(ev) then return end
	Duel.SendtoGrave(eg,nil,REASON_RULE)
    local cld=Duel.GetFieldGroup(tp,0,LOCATION_DECK)
    if cld:GetCount()<1 then return end
    Duel.ConfirmCards(tp,cld)
    local ds=Duel.GetMatchingGroup(c4014.sfilter,tp,0,LOCATION_DECK,nil,e,tp,eg,ep,ev,re,r,rp)
    if not ds:IsExists(c4014.sfilter,1,nil,e,tp,eg,ep,ev,re,r,rp) then return end
	local dm=ds:Select(tp,1,1,nil):GetFirst()
	Duel.SetTargetCard(dm)
	local tc=Duel.GetFirstTarget()
	local tpe=tc:GetType()
	local te=tc:GetActivateEffect()
	local tg=te:GetTarget()
	local co=te:GetCost()
	local op=te:GetOperation()
	e:SetCategory(te:GetCategory())
	e:SetProperty(te:GetProperty())
	Duel.ClearTargetCard()
	if bit.band(tpe,TYPE_EQUIP+TYPE_CONTINUOUS)~=0 or tc:IsHasEffect(EFFECT_REMAIN_FIELD) then
		if Duel.GetLocationCount(1-tp,LOCATION_SZONE)<=0 then return end
		Duel.MoveToField(tc,tp,1-tp,LOCATION_SZONE,POS_FACEUP,true)
	elseif bit.band(tpe,TYPE_FIELD)~=0 then
		Duel.MoveToField(tc,tp,1-tp,LOCATION_SZONE,POS_FACEUP,true)
	else 
		Duel.MoveToField(tc,tp,1-tp,LOCATION_SZONE,POS_FACEUP,true)
	end
	tc:CreateEffectRelation(te)
	if co then co(te,1-tp,eg,ep,ev,re,r,rp,1) end
	if tg then
		if tc:IsSetCard(0x95) then
			tg(e,1-tp,eg,ep,ev,re,r,rp,1)
		else
			tg(te,1-tp,eg,ep,ev,re,r,rp,1)
		end
	end
	Duel.BreakEffect()
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local etc=g:GetFirst()
	while etc do
		etc:CreateEffectRelation(te)
		etc=g:GetNext()
	end
	if op then 
		if tc:IsSetCard(0x95) then
			op(e,1-tp,eg,ep,ev,re,r,rp)
		else
			op(te,1-tp,eg,ep,ev,re,r,rp)
		end
	end
	tc:ReleaseEffectRelation(te)
	etc=g:GetFirst()
	while etc do
		etc:ReleaseEffectRelation(te)
		etc=g:GetNext()
	end
	if bit.band(tpe,TYPE_EQUIP+TYPE_CONTINUOUS)==0 and bit.band(tpe,TYPE_FIELD)==0 and not tc:IsHasEffect(EFFECT_REMAIN_FIELD) then
		Duel.SendtoGrave(tc,nil,REASON_RULE)
	else
		tc:CancelToGrave(true)
	end
end
