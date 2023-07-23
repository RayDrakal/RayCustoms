--トライアングル・フォース
function c3301.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetOperation(c3301.activate)
	c:RegisterEffect(e1)
end
function c3301.filter(c,tp)
	return c:IsCode(3301)
end
function c3301.activate(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local g=Duel.GetMatchingGroup(c3301.filter,tp,LOCATION_DECK,0,nil)
	local ft=Duel.GetLocationCount(tp,LOCATION_SZONE)
	if ft==0 or g:GetCount()==0 then return end
	if Duel.SelectYesNo(tp,aux.Stringid(3301,0)) then
	local g=Duel.SelectMatchingCard(tp,Card.IsCode,tp,LOCATION_DECK,0,1,ft,nil,3301)
	if g:GetCount()>0 then
		local tc=g:GetFirst()
		while tc do
			Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
			tc=g:GetNext()
		end
	end
	end
end
