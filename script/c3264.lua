--最終突撃命令
function c3264.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c3264.target)
	e1:SetOperation(c3264.activate)
	c:RegisterEffect(e1)
	--Pos Change
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SET_POSITION)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e2:SetValue(POS_FACEUP_ATTACK)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_CANNOT_CHANGE_POSITION)
	c:RegisterEffect(e3)
end
function c3264.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Group.CreateGroup()
	local ht1=Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)
	local ht2=Duel.GetFieldGroupCount(tp,0,LOCATION_DECK)
	if chk==0 then return ht1>2 and ht2>2 end
	Duel.SetOperationInfo(0,CATEGORY_DECKDES,ht1-3,ht2-3,tp,LOCATION_DECK)
end
function c3264.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_DECK,LOCATION_DECK,nil)
	local ht1=Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)
	local ht2=Duel.GetFieldGroupCount(1-tp,LOCATION_DECK,0)
	if e:GetHandler():IsRelateToEffect(e) and ht1>2 and ht2>2 then
		local sg=Duel.SelectMatchingCard(tp,aux.TRUE,tp,LOCATION_DECK,0,3,3,nil)
		local sg2=Duel.SelectMatchingCard(1-tp,aux.TRUE,1-tp,LOCATION_DECK,0,3,3,nil)
		sg:Merge(sg2)
		local tc=sg:GetFirst()
		while tc do
			g:RemoveCard(tc)
			tc=sg:GetNext()
		end
		Duel.SendtoGrave(g,REASON_EFFECT)
	end
end
