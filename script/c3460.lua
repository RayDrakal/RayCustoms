--地縛救魂
function c3460.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(c3460.condition)
	e1:SetTarget(c3460.target)
	e1:SetOperation(c3460.activate)
	c:RegisterEffect(e1)
end
function c3460.filter1(c)
	return (c:IsFusionSetCard(0x21) or c:IsFusionSetCard(0x121f)) and c:IsAbleToHand() and c:IsType(TYPE_MONSTER)
end
function c3460.filter2(c)
	return c:IsAbleToHand() and c:IsType(TYPE_SPELL)
end
function c3460.condition(e,tp,eg,ep,ev,re,r,rp)
	local f1=Duel.GetFieldCard(0,LOCATION_SZONE,5)
	local f2=Duel.GetFieldCard(1,LOCATION_SZONE,5)
	return not ((f1==nil or not f1:IsFaceup()) and (f2==nil or not f2:IsFaceup()))
end
function c3460.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c3460.filter1,tp,LOCATION_GRAVE,0,1,nil)
		and Duel.IsExistingMatchingCard(c3460.filter2,tp,LOCATION_GRAVE,0,1,nil)end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,2,tp,LOCATION_GRAVE)
end
function c3460.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g1=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c3460.filter1),tp,LOCATION_GRAVE,0,1,1,nil)
	if g1:GetCount()>0 then
		local g2=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c3460.filter2),tp,LOCATION_GRAVE,0,1,1,nil)
		if g2:GetCount()>0 then
			g1:Merge(g2)
			Duel.SendtoHand(g1,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g1)
		end
	end
end
