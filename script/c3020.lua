--賢者の石－サバティエル
function c3020.initial_effect(c)
	--search
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(c3020.condition)
	e1:SetCost(c3020.cost)
	e1:SetTarget(c3020.target)
	e1:SetOperation(c3020.operation)
	c:RegisterEffect(e1)
	--atkup
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_ATKCHANGE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCondition(c3020.atcon)
	e2:SetCost(c3020.cost)
	e2:SetTarget(c3020.attg)
	e2:SetOperation(c3020.atop)
	c:RegisterEffect(e2)
	--kuri
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_SEARCH)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_DESTROYED)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e3:SetRange(LOCATION_DECK)
	e3:SetCondition(c3020.kcon)
	e3:SetTarget(c3020.ktg)
	e3:SetOperation(c3020.kop)
	c:RegisterEffect(e3)
end
function c3020.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.PayLPCost(tp,math.floor(Duel.GetLP(tp)/2))
end
function c3020.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(tp,3020)<3
end
function c3020.filter(c)
	return c:IsAbleToHand()
end
function c3020.filter2(c,tp)
	return c:IsControler(tp) and c:IsPreviousLocation(LOCATION_DECK)
end
function c3020.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c3020.filter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function c3020.operation(e,tp,eg,ep,ev,re,r,rp,chk,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	Duel.RegisterFlagEffect(tp,3020,0,0,Duel.GetFlagEffect(tp,3020)+1)
	local g=Duel.SelectMatchingCard(tp,c3020.filter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
	if g:GetCount()>0 then
		local tc=g:GetFirst()
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
			e1:SetCode(EVENT_CHAIN_SOLVED)
			e1:SetCondition(c3020.sccon)
			e1:SetOperation(c3020.scop)
			e1:SetCountLimit(1)
			e1:SetLabel(g:GetFirst():GetCode())
			Duel.RegisterEffect(e1,tp)
			local e2=Effect.CreateEffect(e:GetHandler())
			e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
			e2:SetCode(EVENT_SUMMON_SUCCESS)
			e2:SetOperation(c3020.scop)
			e2:SetCondition(c3020.sccon2)
			e2:SetCountLimit(1)
			e2:SetLabel(g:GetFirst():GetCode())
			Duel.RegisterEffect(e2,tp)
			local e3=e2:Clone()
			e3:SetCode(EVENT_SPSUMMON_SUCCESS)
			Duel.RegisterEffect(e3,tp)
			local e4=e2:Clone()
			e4:SetCode(EVENT_FLIP)
			Duel.RegisterEffect(e4,tp)
			local code=g:GetFirst():GetCode()
			if not c3020[code] then c3020[code]=1
			else c3020[code]=c3020[code]+1 end
		if g:IsExists(c3020.filter2,1,nil,tp) then
		e:GetHandler():CancelToGrave()
		Duel.SendtoDeck(e:GetHandler(),nil,1,REASON_EFFECT)
		end
	end
end
function c3020.atcon(e,tp,eg,ep,ev,re,r,rp)
	return 3<=Duel.GetFlagEffect(tp,3020)
end
function c3020.attg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and chkc:IsFaceup() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsFaceup,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,Card.IsFaceup,tp,LOCATION_MZONE,0,1,1,nil)
end
function c3020.atop(e,tp,eg,ep,ev,re,r,rp,chk,c)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then
	local tc=Duel.GetFirstTarget()
	local e2=Effect.CreateEffect(e:GetHandler())
	local mc=Duel.GetFieldGroupCount(tp,0,LOCATION_MZONE)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_SET_ATTACK_FINAL)
	e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
	e2:SetValue(tc:GetAttack()*mc)
	tc:RegisterEffect(e2)
	end
end
function c3020.kfilter(c,tp)
	return c:IsReason(REASON_BATTLE+REASON_EFFECT) and c:IsCode(57116033)
		and c:IsPreviousLocation(LOCATION_MZONE) and c:GetPreviousControler()==tp
end
function c3020.kcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c3020.kfilter,1,nil,tp)
end
function c3020.ktg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c3020.kop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.IsExistingMatchingCard(nil,tp,LOCATION_DECK,0,1,nil,c) then
	Duel.SendtoHand(c,nil,REASON_EFFECT)
	end
end
function c3020.scfilter(c)
	return c:IsAbleToHand() and c:IsCode(3020)
end
function c3020.sccon(e,tp,eg,ep,ev,re,r,rp)
	local tc
	if re then tc=re:GetHandler() return tc~=e:GetHandler() and tc:IsCode(e:GetLabel()) and c3020[e:GetLabel()]>0 end
	return false
end
function c3020.sccon2(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	return c3020[e:GetLabel()]>0 and tc:IsCode(e:GetLabel())
end
function c3020.scop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.SelectMatchingCard(tp,c3020.scfilter,tp,LOCATION_GRAVE+LOCATION_DECK,0,1,1,nil)
	Duel.SendtoHand(g,nil,REASON_EFFECT)
	c3020[e:GetLabel()]=c3020[e:GetLabel()]-1
end
