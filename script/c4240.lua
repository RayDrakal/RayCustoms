--方界防陣
function c4240.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_PRE_DAMAGE_CALCULATE)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e1:SetCondition(c4240.atkcon)
	e1:SetOperation(c4240.atkop)
	c:RegisterEffect(e1)
end
function c4240.atkcon(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetAttacker()
	local bc=Duel.GetAttackTarget()
	if not bc then return false end
	if tc:IsControler(1-tp) then tc,bc=bc,tc end
	e:SetLabelObject(tc)
	local batk=bc:GetAttack()
	local tatk=tc:GetAttack()
	return bc:IsFaceup() and tc:IsFaceup() and (tatk<batk) and Duel.IsExistingMatchingCard(c4240.spfilter,tp,LOCATION_DECK+LOCATION_HAND,0,2,nil,e,tp,tc:GetCode())
end
function c4240.spfilter(c,e,tp,code)
	return c:IsCode(code) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c4240.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local tc=e:GetLabelObject()
	if chk==0 then
		return not Duel.IsPlayerAffectedByEffect(tp,59822133)
		and Duel.IsExistingMatchingCard(c4240.spfilter,tp,LOCATION_DECK+LOCATION_HAND,0,2,nil,e,tp,tc:GetCode())
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and g:IsExists(c4240.filter2,1,nil,g)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,2,tp,LOCATION_DECK)
end
function c4240.atkop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then return end
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<2 then return end
	if tc:IsRelateToBattle() then
		local code=tc:GetCode()
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
		e1:SetValue(1)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_DAMAGE)
		tc:RegisterEffect(e1)
		local g=Duel.SelectMatchingCard(tp,c4240.spfilter,tp,LOCATION_DECK+LOCATION_HAND,0,2,2,nil,e,tp,code)
		if g:GetCount()>1 then
			Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end
