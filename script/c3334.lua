--ＮＯ１２ エーテリック・マヘス
function c3334.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,nil,12,2)
	c:EnableReviveLimit()
	--overlaysummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(3334,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTarget(c3334.target)
	e1:SetOperation(c3334.op)
	c:RegisterEffect(e1)
	--leave field
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_LEAVE_FIELD)
	e2:SetOperation(c3334.leave)
	c:RegisterEffect(e2)
	e1:SetLabelObject(e2)
end
function c3334.filter(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsType(TYPE_MONSTER)
end
function c3334.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and e:GetHandler():GetOverlayGroup():IsExists(c3334.filter,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,e:GetHandler():GetOverlayCount(),tp,LOCATION_OVERLAY)
end
function c3334.op(e,tp,eg,ep,ev,re,r,rp)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local c=e:GetHandler()
	local tg=e:GetHandler():GetOverlayGroup():Filter(c3334.filter,nil,e,tp)
	if ft<=0 or (Duel.IsPlayerAffectedByEffect(tp,59822133) and tg:GetCount()>1 and ft>1) then return end
	if tg:GetCount()>ft then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		g=tg:Select(tp,ft,ft,nil)
	else
		g=tg
	end
	if g:GetCount()>0 then
		local tc=g:GetFirst()
		while tc do
			Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP)
			c:SetCardTarget(tc)
			tc=g:GetNext()
		end
		Duel.SpecialSummonComplete()
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_PHASE+PHASE_END)
		e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
		e1:SetReset(RESET_PHASE+PHASE_END+RESET_EVENT+0x1fe0000)
		e1:SetRange(LOCATION_MZONE)
		e1:SetCountLimit(1)
		e1:SetLabelObject(sg)
		e1:SetOperation(c3334.rmop)
		c:RegisterEffect(e1)
	end
end
function c3334.desfilter(c,rc)
	return rc:GetCardTarget():IsContains(c)
end
function c3334.leave(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:GetCardTargetCount()>0 then
		local dg=Duel.GetMatchingGroup(c3334.desfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil,c)
		Duel.Destroy(dg,REASON_EFFECT)
	end
end
function c3334.rmop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local dg=Duel.GetMatchingGroup(c3334.desfilter,tp,LOCATION_MZONE,0,nil,c)
	if dg:GetCount()==0 then return end
	local tc=dg:GetFirst()
	if c:IsLocation(LOCATION_MZONE) then
		while tc do
			Duel.Overlay(c,Group.FromCards(tc))
			tc=dg:GetNext()
		end
	end
	g:DeleteGroup()
end
