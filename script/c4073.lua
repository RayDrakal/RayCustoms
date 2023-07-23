--カオス・ブルーム
function c4073.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c4073.target)
	e1:SetOperation(c4073.activate)
	c:RegisterEffect(e1)
end
function c4073.des1filter(c)
	return c:GetAttack()<=1000 and c:IsDestructable() and c:IsFaceup()
end
function c4073.des2filter(c)
	return c:IsDestructable()
end
function c4073.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local ct=Duel.GetMatchingGroupCount(Card.IsCode,tp,LOCATION_GRAVE,0,nil,4073)
	local d1ct=Duel.GetMatchingGroupCount(c4073.des1filter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	local d2ct=Duel.GetMatchingGroupCount(c4073.des2filter,tp,LOCATION_SZONE,LOCATION_SZONE,e:GetHandler())
	local d3ct=Duel.GetMatchingGroupCount(c4073.des2filter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,e:GetHandler())

	if chk==0 then return d1ct~=0 or (0<ct and d2ct~=0) or (1<ct and d3ct~=0) end
	if d1ct~=0 then Duel.SetOperationInfo(0,CATEGORY_DESTROY,d1ct,1,0,0) end
	if 0<ct and d2ct~=0 then Duel.SetOperationInfo(0,CATEGORY_DESTROY,d2ct,1,0,0) end
	if 1<ct and d3ct~=0 then Duel.SetOperationInfo(0,CATEGORY_DESTROY,d3ct,1,0,0) end
end
function c4073.activate(e,tp,eg,ep,ev,re,r,rp)
	local ct=Duel.GetMatchingGroupCount(Card.IsCode,tp,LOCATION_GRAVE,0,nil,4073)
	local d1ct=Duel.GetMatchingGroupCount(c4073.des1filter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	local d2ct=Duel.GetMatchingGroupCount(c4073.des2filter,tp,LOCATION_SZONE,LOCATION_SZONE,e:GetHandler())
	local d3ct=Duel.GetMatchingGroupCount(c4073.des2filter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,e:GetHandler())
	
	if d1ct~=0 then
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectMatchingCard(tp,c4073.des1filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
		Duel.HintSelection(g)
		Duel.Destroy(g,REASON_EFFECT)
	end
	if 0<ct and d2ct~=0 then
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectMatchingCard(tp,c4073.des2filter,tp,LOCATION_SZONE,LOCATION_SZONE,1,1,e:GetHandler())
		Duel.HintSelection(g)
		Duel.Destroy(g,REASON_EFFECT)
	end
	if 1<ct and d3ct~=0 then
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectMatchingCard(tp,c4073.des2filter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,e:GetHandler())
		Duel.HintSelection(g)
		Duel.Destroy(g,REASON_EFFECT)
	end
end
