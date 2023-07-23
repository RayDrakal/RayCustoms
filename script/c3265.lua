--完全破壊－ジェノサイド・ウイルス－
function c3265.initial_effect(c)
	--Activate
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCategory(CATEGORY_DECKDES)
	e1:SetCode(EVENT_BATTLE_DESTROYED)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,47598941)
	e1:SetTarget(c3265.target)
	e1:SetOperation(c3265.activate)
	c:RegisterEffect(e1)
	--
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_BATTLE_DESTROYED)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCondition(c3265.condition)
	e2:SetTarget(c3265.target2)
	e2:SetOperation(c3265.activate)
	c:RegisterEffect(e2)
end
function c3265.condition(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c3265.filter,1,nil,tp)
end
function c3265.filter(c,tp)
	return c:IsAttribute(ATTRIBUTE_DARK) and c:IsAttackBelow(500) and c:GetPreviousControler()==tp
end
function c3265.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DECKDES,nil,0,1-tp,10)
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function c3265.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsRelateToEffect(e) end
	Duel.SetOperationInfo(0,CATEGORY_DECKDES,nil,0,1-tp,10)
end
function c3265.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local sg=Duel.GetFieldGroup(1-tp,LOCATION_DECK,0)
	if sg:GetCount()>10 then
		local g=sg:RandomSelect(1-tp,10)
		Duel.SendtoGrave(g,REASON_EFFECT)
	else
		Duel.SendtoGrave(sg,REASON_EFFECT)
	end
end
