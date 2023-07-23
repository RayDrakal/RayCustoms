--ＮＯ４　エーテリック・アヌビス
function c3330.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,nil,4,2)
	c:EnableReviveLimit()
	--set
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_DESTROYED)
	e1:SetRange(LOCATION_MZONE)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCost(c3330.cost)
	e1:SetTarget(c3330.target)
	e1:SetOperation(c3330.activate)
	c:RegisterEffect(e1)
end
function c3330.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c3330.filter1(c,e,tp)
	return c:IsReason(REASON_EFFECT) and (c:IsType(TYPE_SPELL) or c:IsType(TYPE_TRAP))
		and c:IsPreviousLocation(LOCATION_SZONE) and c:GetPreviousControler()==tp
end
function c3330.con(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c3330.filter1,1,nil,tp)
end
function c3330.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return eg:IsContains(chkc) and c3330.filter1(chkc,e,tp) end
	if chk==0 then return eg:IsExists(c3330.filter1,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=eg:FilterSelect(tp,c3330.filter1,1,1,nil,e,tp)
	Duel.SetTargetCard(g)
end
function c3330.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsSSetable() then
		Duel.SSet(tp,tc)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_TRAP_ACT_IN_SET_TURN)
		e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e1)
	end
end
