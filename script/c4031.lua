--RR－ファイナル・フォートレス・ファルコン
function c4031.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsRace,RACE_WINDBEAST),12,3)
	c:EnableReviveLimit()
	--return
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCost(c4031.cost)
	e1:SetOperation(c4031.operation)
	c:RegisterEffect(e1)
	--chain attack
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_DAMAGE_STEP_END)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c4031.atcon)
	e2:SetCost(c4031.atcost)
	e2:SetOperation(c4031.atop)
	c:RegisterEffect(e2)
end
function c4031.rfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xba)
end
function c4031.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST)
	and Duel.IsExistingMatchingCard(c4031.rfilter,tp,LOCATION_REMOVED,0,1,nil) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c4031.operation(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c4031.rfilter,tp,LOCATION_REMOVED,0,nil)
	Duel.SendtoGrave(g,REASON_EFFECT+REASON_RETURN)
end
function c4031.atcon(e,tp,eg,ep,ev,re,r,rp)
	local ac=Duel.GetAttacker()
	e:SetLabelObject(ac)
	return ac:IsSetCard(0xba)
end
function c4031.atcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local ov=c:GetOverlayCount()
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,ov,REASON_COST) and 0<ov end
	e:GetHandler():RemoveOverlayCard(tp,ov,ov,REASON_COST)
end
function c4031.atop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=e:GetLabelObject()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_DAMAGE_STEP_END)
	e1:SetRange(LOCATION_MZONE)
	e1:SetOperation(c4031.atop2)
	e1:SetReset(RESET_PHASE+PHASE_END+RESET_EVENT+0x1fe0000)
	tc:RegisterEffect(e1)
	--attack cost
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_ATTACK_COST)
	e2:SetCost(c4031.ccost)
	e2:SetOperation(c4031.cop)
	e2:SetReset(RESET_PHASE+PHASE_END+RESET_EVENT+0x1fe0000)
	tc:RegisterEffect(e2)
	--cannot direct
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_CANNOT_DIRECT_ATTACK)
	e3:SetReset(RESET_PHASE+PHASE_END+RESET_EVENT+0x1fe0000)
--	c:RegisterEffect(e3)
	Duel.ChainAttack()
end
function c4031.cfilter2(c)
	return c:IsType(TYPE_XYZ) and c:IsSetCard(0xba) and c:IsAbleToRemoveAsCost()
end
function c4031.ccost(e,c,tp)
	return Duel.IsExistingMatchingCard(c4031.cfilter2,tp,LOCATION_GRAVE,0,1,nil)
end
function c4031.cop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c4031.cfilter2,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c4031.atop2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetAttacker()==c then
		Duel.ChainAttack()
	end
end
