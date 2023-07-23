--帝王海馬
function c3012.initial_effect(c)
	--triple tribute
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EVENT_ADJUST)
	e1:SetOperation(c3012.operation)
	c:RegisterEffect(e1)
	--summon success
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetOperation(c3012.sumsuc)
	e2:SetTarget(c3012.regtg)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_SUMMON_SUCCESS)
	c:RegisterEffect(e3)
	--spsummon
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_DAMAGE+CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCost(c3012.spcost)
	e4:SetTarget(c3012.sptarget)
	e4:SetOperation(c3012.spoperation)
	c:RegisterEffect(e4)
end
function c3012.filter(c)
	return c:IsAttribute(ATTRIBUTE_DEVINE) and c:IsType(TYPE_MONSTER)
end
function c3012.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(c3012.filter,c:GetControler(),LOCATION_HAND,LOCATION_HAND,nil)
	local tc=g:GetFirst()
	while tc do
		local tck=Duel.CreateToken(tp,3012)
		if tc:GetFlagEffect(3012)==0 then
			local e1=Effect.CreateEffect(tc)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_LIMIT_SUMMON_PROC)
			e1:SetCondition(c3012.ttcon)
			e1:SetOperation(c3012.ttop)
			e1:SetValue(SUMMON_TYPE_ADVANCE)
			e1:SetLabelObject(tck)
			e1:SetReset(RESET_EVENT+EVENT_ADJUST,1)
			tc:RegisterEffect(e1)
			tc:RegisterFlagEffect(3012,RESET_EVENT+EVENT_ADJUST,0,1) 	
		end
		tc=g:GetNext()
	end
end
function c3012.cfilter(c)
	return c:IsCode(3012)
end
function c3012.ttcon(e,c)
	if c==nil then return true end
	return (Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>-3 and Duel.GetTributeCount(c)>=3) or Duel.IsExistingMatchingCard(c3012.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c3012.ttop(e,tp,eg,ep,ev,re,r,rp,c)
	if Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>-3 and Duel.GetTributeCount(c)>=3 then
	if Duel.SelectYesNo(tp,aux.Stringid(3012,0)) then
	local g=Duel.SelectTribute(tp,c,3,3)
	c:SetMaterial(g)
	Duel.Release(g,REASON_SUMMON+REASON_MATERIAL)
	end
	else
	local g=Duel.SelectMatchingCard(tp,c3012.cfilter,tp,LOCATION_MZONE,0,1,1,nil)
	c:SetMaterial(g)
	Duel.Release(g,REASON_SUMMON+REASON_MATERIAL)
	end
end
function c3012.thfilter(c)
	return c:IsCode(3014) or c:IsCode(10000040) and c:IsAbleToHand()
end
function c3012.regtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c3012.thfilter,tp,LOCATION_DECK,0,1,nil) end
end
function c3012.sumsuc(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,3012)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c3012.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c3012.spfilter(c,e,tp)
	return c:IsAttribute(ATTRIBUTE_DEVINE) and c:IsCanBeSpecialSummoned(e,0,tp,true,false)
end
function c3012.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsReleasable() end
	Duel.Release(e:GetHandler(),REASON_COST)
end
function c3012.sptarget(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c3012.spfilter,tp,LOCATION_DECK+LOCATION_HAND+LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,3,tp,LOCATION_DECK)
end
function c3012.spoperation(e,tp,eg,ep,ev,re,r,rp)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if ft<=0 then return end
	if ft>3 then ft=3 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c3012.spfilter,tp,LOCATION_DECK+LOCATION_HAND+LOCATION_GRAVE,0,1,ft,nil,e,tp)
	if g:GetCount()~=0 then
		Duel.SpecialSummon(g,0,tp,tp,true,false,POS_FACEUP)
	end
end
