--ファーニマル・ウィング
function c3406.initial_effect(c)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_REMOVE+CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_GRAVE)
	e1:SetCondition(c3406.condition)
	e1:SetCost(c3406.cost)
	e1:SetTarget(c3406.target)
	e1:SetOperation(c3406.operation)
	c:RegisterEffect(e1)
end
function c3406.cfilter(c)
	return c:IsFaceup() and c:IsCode(70245411)
end
function c3406.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c3406.cfilter,tp,LOCATION_ONFIELD,0,1,nil)
end
function c3406.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end
function c3406.filter(c)
	return c:IsCode(3406) and c:IsAbleToRemove()
end
function c3406.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_GRAVE) and c3406.filter(chkc) end
	if chk==0 then return Duel.IsPlayerCanDraw(tp,2) and Duel.IsExistingTarget(c3406.filter,tp,LOCATION_GRAVE,0,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectTarget(tp,c3406.filter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,2)
end
function c3406.tgfilter(c)
	return c:IsFaceup() and c:IsCode(70245411) and c:IsReleasableByEffect()
end
function c3406.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)~=0
		and Duel.Draw(tp,2,REASON_EFFECT)~=0 and Duel.IsExistingMatchingCard(c3406.tgfilter,tp,LOCATION_ONFIELD,0,1,nil)
		and Duel.IsPlayerCanDraw(tp,1) and Duel.SelectYesNo(tp,aux.Stringid(3406,0)) then
		Duel.BreakEffect()
		local g=Duel.SelectMatchingCard(tp,c3406.tgfilter,tp,LOCATION_ONFIELD,0,1,1,nil)
		if Duel.Release(g,REASON_EFFECT)>0 then
			Duel.Draw(tp,1,REASON_EFFECT)
		end
	end
end
