--究極封印開放儀式術
function c3393.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(c3393.cost)
	e1:SetTarget(c3393.target)
	e1:SetOperation(c3393.activate)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetRange(LOCATION_GRAVE)
	c:RegisterEffect(e2)
	--replace
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCode(EFFECT_SEND_REPLACE)
	e3:SetTarget(c3393.reptg)
	e3:SetCondition(c3393.repcon)
	e3:SetValue(c3393.repval)
	c:RegisterEffect(e3)
	--replace2
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e5:SetCode(EVENT_TO_GRAVE)
	e5:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e5:SetRange(LOCATION_GRAVE)
	e5:SetCondition(c3393.repcon)
	e5:SetOperation(c3393.repop2)
	c:RegisterEffect(e5)
end
function c3393.cfilter(c)
	return c:IsSetCard(0x40)
end
function c3393.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c3393.cfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,5,nil) end
	local g=Duel.GetMatchingGroup(c3393.cfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,nil)
	local sg=g:Select(tp,5,5,nil)
	Duel.ConfirmCards(1-tp,sg)
end
function c3393.filter(c)
	return c:IsFaceup()
end
function c3393.tgfilter(c)
	return c:IsSetCard(0x40) and c:IsAbleToGrave()
end
function c3393.spfilter(c,e,tp)
	return c:IsCode(3392) and c:IsCanBeSpecialSummoned(e,0,tp,true,true)
end
function c3393.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local g=Duel.GetMatchingGroup(c3393.tgfilter,tp,LOCATION_HAND,0,nil)
		return g:GetCount()>0
			and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
			and Duel.IsExistingMatchingCard(c3393.spfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil,e,tp)
			and Duel.IsExistingMatchingCard(c3393.tdfilter,tp,LOCATION_GRAVE,0,1,nil)
	end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,nil,tp,LOCATION_HAND)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_DECK)
end
function c3393.tdfilter(c)
	return c:IsSetCard(0x40) and c:IsAbleToDeck()
end
function c3393.activate(e,tp,eg,ep,ev,re,r,rp)
	local td=Duel.GetMatchingGroup(c3393.tdfilter,tp,LOCATION_GRAVE,0,nil)
	if td:GetCount()<1 then return end
	Duel.SendtoDeck(td,nil,2,REASON_EFFECT)
	if not td:IsExists(Card.IsLocation,1,nil,LOCATION_DECK) then return end
	local g=Duel.GetMatchingGroup(c3393.tgfilter,tp,LOCATION_HAND,0,nil)
	if g:GetCount()<1 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local tg=g:Select(tp,1,2,nil)
	if Duel.SendtoGrave(tg,REASON_EFFECT)~=0 and tg:IsExists(Card.IsLocation,1,nil,LOCATION_GRAVE) then
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,c3393.spfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,1,nil,e,tp)
		local tc=g:GetFirst()
		if tc then
			Duel.SpecialSummon(tc,0,tp,tp,true,true,POS_FACEUP)
		end
	end
end
function c3393.repfilter(c,tp)
	return c:GetDestination()==LOCATION_GRAVE and c:IsSetCard(0x40)
end
function c3393.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return bit.band(r,REASON_EFFECT)~=0 and eg:IsExists(c3393.repfilter,1,nil,tp) and not re:GetHandler():IsCode(3392) end
	local g=eg:Filter(c3393.repfilter,nil,tp)
	local ct=g:GetCount()
	if ct>0 then
		Duel.SendtoDeck(eg,nil,2,REASON_EFFECT)
	end
	return true
end
function c3393.repfilter2(c,tp)
	return c:IsCode(3392) and c:IsFaceup()
end
function c3393.repcon(e)
	return Duel.IsExistingMatchingCard(c3393.repfilter2,e:GetHandlerPlayer(),LOCATION_ONFIELD,0,1,nil)
end
function c3393.repval(e,c)
	return false
end
function c3393.retfilter(c)
	return c:IsSetCard(0x40) and c:IsReason(REASON_EFFECT) and not c:GetReasonEffect():GetHandler():IsCode(3392)
end
function c3393.repop2(e,tp,eg,ep,ev,re,r,rp)
	local g=eg:Filter(c3393.retfilter,nil)
	if g:GetCount()>0 then
		Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
	end
end
