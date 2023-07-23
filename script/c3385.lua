--運命の宝札
function c3385.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_ATKCHANGE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c3385.target)
	e1:SetOperation(c3385.activate)
	c:RegisterEffect(e1)
end
function c3385.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>1 end
	Duel.SetOperationInfo(0,CATEGORY_DICE,nil,0,tp,1)
end
function c3385.activate(e,tp,eg,ep,ev,re,r,rp)
	local d=Duel.TossDice(tp,1)
	if Duel.Draw(tp,d,REASON_EFFECT) then
		local g=Duel.GetDecktopGroup(tp,d)
		g:FilterCount(Card.IsAbleToRemove,nil)
		Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
	end
end
