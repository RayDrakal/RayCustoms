--ダークネス・アウトサイダー
function c3061.initial_effect(c)
	--sp summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(3061,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCost(c3061.cost)
	e1:SetTarget(c3061.sptg)
	e1:SetOperation(c3061.spop)
	c:RegisterEffect(e1)
end
function c3061.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD,nil)
end
function c3061.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(aux.TRUE,tp,0,LOCATION_DECK,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c3061.filter(c)
	return c:IsType(TYPE_MONSTER)
end
function c3061.spop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_SPSUMMON)
	local tg=Duel.GetFieldGroup(tp,0,LOCATION_DECK)
    Duel.ConfirmCards(tp,tg)
	local g=Duel.SelectMatchingCard(tp,c3061.filter,tp,0,LOCATION_DECK,1,1,nil)
	if g:GetCount()>0 then
		if Duel.SendtoDeck(c,1-tp,0,REASON_EFFECT)~=0 then
			Duel.SpecialSummon(g,0,tp,tp,true,false,POS_FACEUP)
		end
	end
end
