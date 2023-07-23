--機皇創世
function c4076.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(4076,0))
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCost(c4076.spcost)
	e1:SetTarget(c4076.sptg)
	e1:SetOperation(c4076.spop)
	c:RegisterEffect(e1)
	--destroy replace
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_SZONE)
	e2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e2:SetCode(EFFECT_DESTROY_REPLACE)
	e2:SetTarget(c4076.reptg)
	e2:SetValue(c4076.repval)
	e2:SetOperation(c4076.repop)
	c:RegisterEffect(e2)
end
function c4076.handfilter(c,code)
	return c:IsCode(code) and c:IsAbleToGraveAsCost()
end
function c4076.gravefilter(c,code)
	return c:IsCode(code) and c:IsAbleToRemoveAsCost()
end
function c4076.spfilter(c,e,sp)
	return c:IsCode(4050) or c:IsCode(63468625) and c:IsCanBeSpecialSummoned(e,0,sp,true,true)
end
function c4076.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return 
		(Duel.IsExistingMatchingCard(c4076.handfilter,tp,LOCATION_HAND,0,1,e:GetHandler(),4069) or Duel.IsExistingMatchingCard(c4076.gravefilter,tp,LOCATION_GRAVE,0,1,e:GetHandler(),4069) )
		and (Duel.IsExistingMatchingCard(c4076.handfilter,tp,LOCATION_HAND,0,1,e:GetHandler(),4064) or Duel.IsExistingMatchingCard(c4076.gravefilter,tp,LOCATION_GRAVE,0,1,e:GetHandler(),4064))
		and (Duel.IsExistingMatchingCard(c4076.handfilter,tp,LOCATION_HAND,0,1,e:GetHandler(),4059) or Duel.IsExistingMatchingCard(c4076.gravefilter,tp,LOCATION_GRAVE,0,1,e:GetHandler(),4059))
	end
	local wg=Duel.GetMatchingGroup(c4076.handfilter,tp,LOCATION_HAND,0,nil,4069)
	wg:Merge(Duel.GetMatchingGroup(c4076.gravefilter,tp,LOCATION_GRAVE,0,nil,4069))
	local sg=Duel.GetMatchingGroup(c4076.handfilter,tp,LOCATION_HAND,0,nil,4064)
	sg:Merge(Duel.GetMatchingGroup(c4076.gravefilter,tp,LOCATION_GRAVE,0,nil,4064))
	local gg=Duel.GetMatchingGroup(c4076.handfilter,tp,LOCATION_HAND,0,nil,4059)
	gg:Merge(Duel.GetMatchingGroup(c4076.gravefilter,tp,LOCATION_GRAVE,0,nil,4059))
	local cg=wg:Select(tp,1,1,nil)
	cg:Merge(sg:Select(tp,1,1,nil))
	cg:Merge(gg:Select(tp,1,1,nil))
	local cg2=cg:Filter(Card.IsLocation,nil,LOCATION_HAND)
	Duel.SendtoGrave(cg2,REASON_COST)
	cg:Sub(cg2)
	Duel.Remove(cg:Filter(Card.IsLocation,nil,LOCATION_GRAVE),POS_FACEUP,REASON_COST)
end
function c4076.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
	and Duel.IsExistingMatchingCard(c4076.spfilter,tp,0x13,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,0x13)
end
function c4076.spop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local gs=Duel.SelectMatchingCard(tp,c4076.spfilter,tp,0x13,0,1,1,nil,e,tp)
	local tc=gs:GetFirst()
	if tc and Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP) then
			tc:CompleteProcedure()
			local c=e:GetHandler()
		if c:IsRelateToEffect(e) then
			Duel.Equip(tp,c,tc)
			c:CancelToGrave()
			--Add Equip limit
			local e1=Effect.CreateEffect(tc)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_EQUIP_LIMIT)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetReset(RESET_EVENT+0x1fe0000)
			e1:SetValue(c4076.eqlimit)
			c:RegisterEffect(e1)
		end
		Duel.SpecialSummonComplete()
	end
end
function c4076.eqlimit(e,c)
	return e:GetOwner()==c
end
function c4076.reprfilter(c)
	return c:IsCode(4052,4053,4054,4055,4056,4057,4058,4060,4061,4062,4063,4065,4066,4067,4068,39648965,68140974,75733063,31930787,1237678,4545683) and c:IsAbleToRemove()
end
function c4076.repfilter(c,e,tp)
	return c==e:GetHandler():GetEquipTarget() and c:IsReason(REASON_EFFECT+REASON_BATTLE)
end
function c4076.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return eg:IsExists(c4076.repfilter,1,nil,e,tp) and Duel.IsExistingMatchingCard(c4076.reprfilter,tp,LOCATION_GRAVE,0,1,nil) end
	return Duel.SelectYesNo(tp,aux.Stringid(4076,0))
end
function c4076.repval(e,c)
	return c==e:GetHandler():GetEquipTarget()
end
function c4076.repop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.SelectMatchingCard(tp,c4076.reprfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
end
