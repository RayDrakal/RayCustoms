--流転する生命力
function c2819.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(c2819.cost)
	e1:SetTarget(c2819.target)
	e1:SetOperation(c2819.operation)
	c:RegisterEffect(e1)
end
function c2819.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(nil,tp,LOCATION_HAND,0,e:GetHandler())
	if chk==0 then return g:GetCount()>3 and g:GetCount()==g:FilterCount(Card.IsAbleToGraveAsCost,nil) end
	Duel.SendtoGrave(g,REASON_COST)
end
function c2819.filter(c)
	return c:IsType(TYPE_SPELL) and c:IsSSetable()
end
function c2819.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:GetLocation()==LOCATION_GRAVE and chkc:GetControler()==tp and c2819.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c2819.filter,tp,LOCATION_GRAVE,LOCATION_GRAVE,4,nil)
		and Duel.GetLocationCount(tp,LOCATION_SZONE)>3 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,c2819.filter,tp,LOCATION_GRAVE,LOCATION_GRAVE,4,4,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,g:GetCount(),0,0)
end
function c2819.operation(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local sg=g:Filter(Card.IsRelateToEffect,nil,e)
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<sg:GetCount() then return end
	if sg:GetCount()>0 then
		Duel.SSet(tp,sg)
		Duel.ConfirmCards(1-tp,g)
	end
end
