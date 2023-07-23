--ＤＤＤシンクロ
function c3433.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c3433.target)
	e1:SetOperation(c3433.activate)
	c:RegisterEffect(e1)
end
function c3433.filter1(c,e,tp)
	local lv=c:GetLevel()
	return c:IsSetCard(0x10af) and c:IsType(TYPE_SYNCHRO) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_SYNCHRO,tp,false,false)
		and Duel.IsExistingMatchingCard(c3433.filter2,tp,LOCATION_ONFIELD+LOCATION_HAND,0,1,nil,tp,lv)
end
function c3433.filter2(c,tp,lv)
	local rlv=lv-c:GetLevel()
	local rg=Duel.GetMatchingGroup(c3433.filter3,tp,LOCATION_MZONE+LOCATION_HAND,0,c)
	if c:IsCode(3433) then 
		rlv=lv-2
		rg=Duel.GetMatchingGroup(c3433.filter4,tp,LOCATION_MZONE+LOCATION_HAND,0,c)
	end
	return rlv>0 and (c:IsType(TYPE_TUNER) or c:IsCode(3433))
		and rg:CheckWithSumEqual(Card.GetLevel,rlv,1,63) and c:IsSetCard(0xaf)
end
function c3433.filter3(c)
	return c:GetLevel()>0 and not c:IsType(TYPE_TUNER)
end
function c3433.filter4(c)
	return c:GetLevel()>0 and c:IsCode(47198668) and not c:IsType(TYPE_TUNER)
end
function c3433.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 
		and Duel.IsExistingMatchingCard(c3433.filter1,tp,LOCATION_EXTRA,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c3433.activate(e,tp,eg,ep,ev,re,r,rp)
	local chkf=Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and PLAYER_NONE or tp
	local sg1=Duel.GetMatchingGroup(c3433.filter1,tp,LOCATION_EXTRA,0,nil,e,tp)
	if sg1:GetCount()>0 then
		local sg=sg1:Clone()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local tg=sg:Select(tp,1,1,nil)
		local tc=tg:GetFirst()
		local lv=tc:GetLevel()
		local tuner=Duel.SelectMatchingCard(tp,c3433.filter2,tp,LOCATION_ONFIELD+LOCATION_HAND,0,1,1,nil,tp,lv)
		local rlv=lv-tuner:GetFirst():GetLevel()
		local rg=Duel.GetMatchingGroup(c3433.filter3,tp,LOCATION_MZONE+LOCATION_HAND,0,tuner:GetFirst())
		if tuner:GetFirst():IsCode(3433) then
			rlv=lv-2
			rg=Duel.GetMatchingGroup(c3433.filter4,tp,LOCATION_MZONE+LOCATION_HAND,0,c)
		end
		local mat1=rg:SelectWithSumEqual(tp,Card.GetLevel,rlv,1,63)
		mat1:Merge(tuner)
		tc:SetMaterial(mat1)
		Duel.SendtoGrave(mat1,REASON_EFFECT+REASON_MATERIAL+REASON_SYNCHRO)
		Duel.BreakEffect()
		Duel.SpecialSummon(tc,SUMMON_TYPE_SYNCHRO,tp,tp,false,false,POS_FACEUP)
		tc:CompleteProcedure()
	end
end
