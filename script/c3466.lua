--写真融合
function c3466.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(3466,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_FUSION_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--fusion
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_FUSION_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1)
	e2:SetTarget(c3466.target)
	e2:SetOperation(c3466.operation)
	c:RegisterEffect(e2)
end
function c3466.filter0(c,e,tp)
	return (c:IsControler(tp) or c:IsFaceup()) and c:IsCanBeFusionMaterial() and Duel.IsExistingMatchingCard(c3466.filter1,tp,0,LOCATION_MZONE,1,nil,e,tp,c)
end
function c3466.filter1(c,e,tp,mc)
	local mg=Group.FromCards(c,mc)
	return c:IsControler(1-tp) and c:IsFaceup() and c:IsCanBeFusionMaterial() and Duel.IsExistingMatchingCard(c3466.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg)
end
function c3466.filter2(c,e,tp,mg)
	return c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false) and c:CheckFusionMaterial(mg,nil)
end
function c3466.filter3(c,e,tp)
	return (c:IsControler(tp) or c:IsFaceup()) and c:IsCanBeFusionMaterial()
end
function c3466.filter4(c,e,tp,mg)
	mg:AddCard(c)
	return c:IsControler(1-tp) and c:IsFaceup() and c:IsCanBeFusionMaterial() and Duel.IsExistingMatchingCard(c3466.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg)
end
function c3466.filterex(c,e,tp)
	local mg=Duel.GetMatchingGroup(c3466.filter3,tp,LOCATION_MZONE,0,nil,e,tp)
	if not mg or mg:GetCount()==0 then return false end
	local mg2=Duel.GetMatchingGroup(c3466.filter4,tp,0,LOCATION_MZONE,nil,e,tp,mg)
	if not mg2 or mg2:GetCount()==0 then return false end
	mg:Merge(mg2)
	return c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false) and c:CheckFusionMaterial(mg,nil)
end
function c3466.filtermg(c,e,tp,tc)
	return c:IsCanBeFusionMaterial() and Duel.IsExistingMatchingCard(c3466.filter1,tp,0,LOCATION_MZONE,1,nil,e,tp,c,tc)
end
function c3466.filter5(c,e,tp,mc,tc)
	local mg=Group.FromCards(c,mc)
	return c:IsControler(1-tp) and c:IsFaceup() and c:IsCanBeFusionMaterial() and tc:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false) and tc:CheckFusionMaterial(mg,nil)
end
function c3466.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c3466.filter0,tp,LOCATION_MZONE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c3466.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local sg=Duel.SelectMatchingCard(tp,c3466.filterex,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
	if not sg or sg:GetCount()==0 then return end
	local tc=sg:GetFirst()
	local mg=Duel.SelectMatchingCard(tp,c3466.filtermg,tp,LOCATION_MZONE,0,1,1,nil,e,tp,tc)
	if not mg or mg:GetCount()==0 then return end
	local tc2=mg:GetFirst()
	tc:SetMaterial(mg)
	Duel.SendtoGrave(tc2,REASON_MATERIAL+REASON_FUSION+REASON_EFFECT)
	Duel.BreakEffect()
	Duel.SpecialSummonStep(tc,SUMMON_TYPE_FUSION,tp,tp,false,false,POS_FACEUP)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetOperation(c3466.desop)
	e1:SetReset(RESET_EVENT+0x1fe0000)
	e1:SetCountLimit(1)
	tc:RegisterEffect(e1)
	Duel.SpecialSummonComplete()
	tc:CompleteProcedure()
end
function c3466.desop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Destroy(e:GetHandler(),REASON_EFFECT)
end
