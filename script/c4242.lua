--方界業
function c4242.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c4242.target)
	c:RegisterEffect(e1)
	--lp halve
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(4242,1))
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCondition(c4242.lpcon)
	e2:SetOperation(c4242.lpop)
	c:RegisterEffect(e2)
	--to hand
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(4242,2))
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCost(c4242.thcost)
	e3:SetTarget(c4242.thtg)
	e3:SetOperation(c4242.thop)
	c:RegisterEffect(e3)
end
function c4242.tgfilter(c)
	return c:IsCode(15610297) and c:IsAbleToGrave()
end
function c4242.filter(c)
	return c:IsFaceup() and c:IsSetCard(0xe3) and not c:IsCode(15610297) and not c:IsCode(4237) and not c:IsCode(30270176) and not c:IsCode(72664875) and not c:IsCode(20137754)
end
function c4242.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c4242.filter(chkc) end
	if chk==0 then return true end
	if Duel.IsExistingTarget(c4242.filter,tp,LOCATION_MZONE,0,1,nil)
		and Duel.IsExistingMatchingCard(c4242.tgfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil)
		and Duel.SelectYesNo(tp,aux.Stringid(4242,0)) then
		e:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_TOGRAVE)
		e:SetProperty(EFFECT_FLAG_CARD_TARGET)
		e:SetOperation(c4242.activate)
		Duel.SelectTarget(tp,c4242.filter,tp,LOCATION_MZONE,0,1,1,nil)
		Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
	else
		e:SetCategory(0)
		e:SetProperty(0)
		e:SetOperation(nil)
	end
end
function c4242.activate(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c4242.tgfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,99,nil)
	if Duel.SendtoGrave(g,REASON_EFFECT)~=0 then
		local og=Duel.GetOperatedGroup()
		local n=og:FilterCount(Card.IsLocation,nil,LOCATION_GRAVE)
		local tc=Duel.GetFirstTarget()
		if tc:IsRelateToEffect(e) and tc:IsFaceup() and n>0 then
			Duel.BreakEffect()
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UPDATE_ATTACK)
			if tc:IsCode(4231) or tc:IsCode(4232) or tc:IsCode(4233) then
				e1:SetValue(n*1000)
			else
				e1:SetValue(n*800)
			end
			e1:SetReset(RESET_EVENT+0x1fe0000)
			local ct=tc:GetFlagEffectLabel(4242)
			if not ct then
				tc:RegisterFlagEffect(4242,RESET_EVENT+0x1fe0000,0,1,1)
				tc:SetFlagEffectLabel(4242,n)
			else
				tc:SetFlagEffectLabel(4242,ct+n)
			end
			tc:RegisterEffect(e1)
		end
	end
end
function c4242.lpcon(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	return Duel.GetTurnPlayer()~=tp and re:IsActiveType(TYPE_MONSTER) and rc and rc:IsSetCard(0xe3)
		and eg:IsExists(Card.IsCode,1,nil,15610297)
end
function c4242.lpop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SendtoGrave(c,REASON_EFFECT)~=0 and c:IsLocation(LOCATION_GRAVE) then
		Duel.SetLP(1-tp,math.ceil(Duel.GetLP(1-tp)/2))
	end
end
function c4242.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end
function c4242.thfilter(c)
	return c:IsSetCard(0xe3) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c4242.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c4242.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c4242.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c4242.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
