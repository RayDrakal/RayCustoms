--愚者の種蒔き
function c4117.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetCategory(CATEGORY_DECKDES)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetTarget(c4117.target)
	e2:SetOperation(c4117.op)
	c:RegisterEffect(e2)

end
function c4117.filter(c)
	return c:IsSetCard(0x5) and c:IsFaceup() 
end
function c4117.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) end
	if chk==0 then return Duel.IsExistingTarget(c4117.filter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c4117.filter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c4117.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	local res=0
	if not c:IsRelateToEffect(e) then return end
	if c:IsHasEffect(73206827) then
		res=1-Duel.SelectOption(tp,60,61)
	else res=Duel.TossCoin(tp,1) end
	local dc=math.floor(tc:GetAttack()/300)
	if res==1 then
		Duel.DiscardDeck(tp,dc,REASON_EFFECT)
	else
		Duel.DiscardDeck(1-tp,dc,REASON_EFFECT)
	end
end
