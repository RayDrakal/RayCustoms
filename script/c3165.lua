--無限光アイン・ソフ・オウル
function c3165.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_END_PHASE)
	e1:SetTarget(c3165.target1)
	e1:SetCost(c3165.cost)
	e1:SetOperation(c3165.operation)
	c:RegisterEffect(e1)
	--instant
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetHintTiming(0,TIMING_END_PHASE)
	e2:SetTarget(c3165.target2)
	e2:SetOperation(c3165.operation)
	c:RegisterEffect(e2)
	--can not to deck
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_CANNOT_TO_DECK)
	e3:SetRange(LOCATION_SZONE)
	e3:SetTargetRange(LOCATION_MZONE,0)
	e3:SetTarget(c3165.tgn)
	c:RegisterEffect(e3)
	--sefiron 2
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(3165,2))
	e4:SetCountLimit(1)
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCondition(c3165.sfcon2)
	e4:SetTarget(c3165.sfst)
	e4:SetOperation(c3165.sfsm)
	c:RegisterEffect(e4)
	--
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetCode(3164)
	e5:SetRange(LOCATION_SZONE)
	e5:SetTargetRange(LOCATION_MZONE,0)
	e5:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x4a))
	e5:SetCondition(c3165.effectcon)
	c:RegisterEffect(e5)
	--sefila counter
	if not c3165.global_check then
		c3165.global_check=true
		c3165[0]=0
		c3165[1]=0
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_SUMMON_SUCCESS)
		ge1:SetOperation(c3165.checkop)
		ge1:SetCondition(c3165.sfcon)
		Duel.RegisterEffect(ge1,0)
		local ge2=ge1:Clone()
		ge2:SetCode(EVENT_SPSUMMON_SUCCESS)
		Duel.RegisterEffect(ge2,0)
	end
end
function c3165.costfilter(c)
	return c:IsFaceup() and c:GetCode()==3164 and c:IsAbleToGraveAsCost()
end
function c3165.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c3165.costfilter,tp,LOCATION_SZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c3165.costfilter,tp,LOCATION_SZONE,0,1,1,nil)
	Duel.SendtoGrave(g,REASON_COST)
end
function c3165.spfilter(c,e,tp)
	return c:IsLevelAbove(10) and c:IsType(TYPE_MONSTER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c3165.target1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local b1=Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c3165.spfilter,tp,LOCATION_HAND,0,1,nil,e,tp)
	e:SetCategory(0)
	if Duel.SelectYesNo(tp,aux.Stringid(3165,0)) then
		e:SetCategory(CATEGORY_SPECIAL_SUMMON)
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
	else
		e:SetLabel(1)
	end
end
function c3165.operation(e,tp,eg,ep,ev,re,r,rp)
	if e:GetLabel()==1 or not e:GetHandler():IsRelateToEffect(e) then return end
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,c3165.spfilter,tp,LOCATION_HAND,0,1,1,nil,e,tp)
		if g:GetCount()>0 then
			Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
		end
end
function c3165.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	local b1=Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c3165.spfilter,tp,LOCATION_HAND,0,1,nil,e,tp)
	if chk==0 then return b1 end
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function c3165.tgn(e,c)
	return c:IsSetCard(0x4a)
end
function c3165.tf1(c,e,tp)
	return c:IsCode(3162) or c:IsCode(8967776) and c:IsCanBeSpecialSummoned(e,0,tp,true,true)
end
function c3165.sfst(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
	 and Duel.IsExistingMatchingCard(c3165.tf1,tp,0x13,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,0x13)
end
function c3165.sfsm(e,tp,eg,ep,ev,re,r,rp)
	if chk==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if ft<=0 then return end
	local tc1=Duel.SelectMatchingCard(tp,c3165.tf1,tp,0x13,0,1,1,nil,e,tp)
	if tc1 then
		if Duel.SpecialSummon(tc1,0,tp,tp,true,true,POS_FACEUP)~=0 then
			Duel.SendtoGrave(e:GetHandler(),REASON_EFFECT)
		end
	end
end
function c3165.sfcfilter(c)
	return c:IsSetCard(0x4a)
end
function c3165.sfcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c3165.sfcfilter,1,nil,nil,tp)
end
function c3165.sfop(c,e,tp,eg,ep,ev,re,r,rp)
	local ct=c:GetLabel()
	c:SetLabel(ct+1)
	if ct+1>9 then
	Duel.RegisterFlagEffect(tp,3165,RESET_EVENT,0,1)
	end
end
function c3165.sfcon2(e,tp,eg,ep,ev,r,rp,chk)
	return c3165[tp]>0
end
function c3165.sfcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToGraveAsCost() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST)
end
function c3165.checkop(e,tp,eg,ep,ev,re,r,rp)
	c3165[rp]=c3165[rp]+1
end
function c3165.effectcon(e)
	local c=e:GetHandler()
	return c:GetFlagEffect(3164)==0 or c:IsHasEffect(EFFECT_CANNOT_DISABLE)
end
