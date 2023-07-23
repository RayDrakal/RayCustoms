--亜空間バトル
function c4375.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOGRAVE+CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c4375.target)
	e1:SetOperation(c4375.activate)
	c:RegisterEffect(e1)
end
function c4375.filter(c)
	return c:IsAbleToHand() and c:IsAbleToGrave()
end
function c4375.filter2(c)
	return c:IsAbleToHand() and c:IsAbleToGrave() and c:IsType(TYPE_MONSTER)
end
function c4375.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c4375.filter2,tp,LOCATION_DECK,0,3,nil)
		and Duel.IsExistingMatchingCard(c4375.filter,tp,0,LOCATION_DECK,3,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,nil,tp,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,nil,1-tp,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,nil,tp,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,nil,1-tp,LOCATION_DECK)
end
function c4375.activate(e,tp,eg,ep,ev,re,r,rp)
	local g1=Duel.GetMatchingGroup(c4375.filter2,tp,LOCATION_DECK,0,nil)
	local g2=Duel.GetMatchingGroup(c4375.filter2,1-tp,LOCATION_DECK,0,nil)
	if g1:GetCount()<2 or g2:GetCount()<2 then return end
	local rg1=g1:Select(tp,3,3,nil)
	local rg2=g2:Select(1-tp,3,3,nil)
	local i
	for i=1,3 do
	local rs1=rg1:Select(tp,1,1,nil):GetFirst()
	local rs2=rg2:Select(1-tp,1,1,nil):GetFirst()
	rg1:RemoveCard(rs1)
	rg2:RemoveCard(rs2)
	Duel.ConfirmCards(1-tp,rs1)
	local atk1=rs1:GetAttack()
	Duel.ConfirmCards(tp,rs2)
	local atk2=rs2:GetAttack()
	if atk1>atk2 then
	Duel.SendtoHand(rs1,nil,REASON_EFFECT)
	Duel.SendtoGrave(rs2,REASON_EFFECT)
	Duel.Damage(1-tp,500,REASON_EFFECT)
	elseif atk2>atk1 then
	Duel.SendtoHand(rs2,nil,REASON_EFFECT)
	Duel.SendtoGrave(rs1,REASON_EFFECT)
	Duel.Damage(tp,500,REASON_EFFECT)
	else
	Duel.SendtoGrave(rs1,REASON_EFFECT)
	Duel.SendtoGrave(rs2,REASON_EFFECT)
	end
	end
end
