--天よりの宝札
function c3081.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetOperation(c3081.activate)
	e1:SetTarget(c3081.target)
	c:RegisterEffect(e1)
end
function c3081.activate(e,tp,eg,ep,ev,re,r,rp)
	local ht1=Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)
	if ht1<6 then
		Duel.Draw(tp,6-ht1,REASON_EFFECT)
	end
	local ht2=Duel.GetFieldGroupCount(1-tp,LOCATION_HAND,0)
	if ht2<6 then
		Duel.Draw(1-tp,6-ht2,REASON_EFFECT)
	end
end
function c3081.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local ht=Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)
	local ht2=Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)
	if chk==0 then
	return (ht<6 and Duel.IsPlayerCanDraw(1-tp,6-ht)) or (ht2<6 and Duel.IsPlayerCanDraw(tp,6-ht2)) end
	
	if ht<6 then
		Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,1-tp,6-ht)
	end
	if ht2<6 then
		Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,6-ht2)
	end
end
