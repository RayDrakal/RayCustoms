--超越融合
function c3191.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(3191,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_FUSION_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCost(c3191.cost)
	e1:SetTarget(c3191.target)
	e1:SetOperation(c3191.activate)
	c:RegisterEffect(e1)
end
function c3191.filter0(c,e,tp,mg)
	return mg:IsExists(c3191.filter1,1,nil,e,tp,c)
end
function c3191.filter1(c,e,tp,mc)
	local mg=Group.FromCards(c,mc)
	return Duel.IsExistingMatchingCard(c3191.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg)
end
function c3191.filter2(c,e,tp,mg)
	return c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false) and c:CheckFusionMaterial(mg,nil)
end
function c3191.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,1000) end
	Duel.PayLPCost(tp,1000)
end
function c3191.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() end
	local mg=Duel.GetFusionMaterial(tp):Filter(Card.IsOnField,nil)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and mg:IsExists(c3191.filter0,1,nil,e,tp,mg)
		and not Duel.IsPlayerAffectedByEffect(tp,59822133) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
	if e:IsHasType(EFFECT_TYPE_ACTIVATE) then
		Duel.SetChainLimit(aux.FALSE)
	end
	local mg1=Duel.SelectTarget(tp,c3191.filter0,tp,LOCATION_MZONE,0,1,1,nil,e,tp,mg)
	local mg2=Duel.SelectTarget(tp,c3191.filter0,tp,LOCATION_MZONE,0,1,1,nil,e,tp,mg1)
end
function c3191.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<-1 then return end
	local c=e:GetHandler()
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if g:GetCount()~=2 then return end
	local sg=Duel.SelectMatchingCard(tp,c3191.filter2,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,g)
	local tc=sg:GetFirst()
	tc:SetMaterial(g)
	Duel.SendtoGrave(g,REASON_MATERIAL+REASON_FUSION+REASON_EFFECT)
	Duel.BreakEffect()
	Duel.SpecialSummonStep(tc,SUMMON_TYPE_FUSION,tp,tp,false,false,POS_FACEUP)
	Duel.SpecialSummonComplete()
	tc:CompleteProcedure()
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then return end
	Duel.BreakEffect()
	local tc=g:GetFirst()
	while tc do
		if tc:GetLocation()==LOCATION_GRAVE and Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP_ATTACK) then
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_SET_ATTACK_FINAL)
			e1:SetValue(0)
			e1:SetReset(RESET_EVENT+0x1fe0000)
			tc:RegisterEffect(e1)
		end
		tc=g:GetNext()
	end
	if g:Filter(Card.IsOnField,nil):GetCount()~=2 then return end
	Duel.SpecialSummonComplete()
	Duel.BreakEffect()
	if Duel.SelectYesNo(tp,aux.Stringid(3191,0)) then
		local res=1-Duel.SelectOption(tp,aux.Stringid(3191,1),aux.Stringid(3191,2))
		if res==1 then
			local tc=g:GetFirst()
			while tc do
				local e2=Effect.CreateEffect(c)
				e2:SetType(EFFECT_TYPE_SINGLE)
				e2:SetCode(EFFECT_CHANGE_LEVEL)
				e2:SetValue(4)
				e2:SetReset(RESET_EVENT+0x1fe0000)
				tc:RegisterEffect(e2)
				tc=g:GetNext()
			end
		else
			local hg=g:Select(tp,1,1,nil)
			local e3=Effect.CreateEffect(e:GetHandler())
			e3:SetType(EFFECT_TYPE_SINGLE)
			e3:SetCode(EFFECT_ADD_TYPE)
			e3:SetReset(RESET_EVENT+0x1fe0000)
			e3:SetValue(TYPE_TUNER)
			hg:GetFirst():RegisterEffect(e3)
			Duel.HintSelection(hg)
		end
	end
end

