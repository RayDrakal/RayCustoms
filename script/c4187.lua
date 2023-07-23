--ゲイザー・シャーク
function c4187.initial_effect(c)
	--xyz
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(4187,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_GRAVE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetTarget(c4187.target)
	e1:SetOperation(c4187.operation)
	c:RegisterEffect(e1)
	if not c4187.global_check then
		c4187.global_check=true
		local ge1=Effect.GlobalEffect()
		ge1:SetType(EFFECT_TYPE_FIELD)
		ge1:SetCode(EFFECT_TO_GRAVE_REDIRECT)
		ge1:SetTargetRange(LOCATION_OVERLAY,LOCATION_OVERLAY)
		ge1:SetTarget(aux.TargetBoolFunction(Card.IsCode,4187))
		ge1:SetValue(LOCATION_REMOVED)
		Duel.RegisterEffect(ge1,0)
	end
	--
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL)
	e2:SetCondition(c4187.xcon)
	e2:SetValue(1)
	c:RegisterEffect(e2)
end
function c4187.xcon(e)
	return not e:GetHandler():IsLocation(LOCATION_GRAVE)
end
function c4187.filter(c,e,tp)
	return c:IsCode(4187)
end
function c4187.xyzfilter(c,mg)
	return c:IsXyzSummonable(mg)
end
function c4187.xmfilter(c,xyz,tp,mg)
	return 
end
function c4187.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local mg1=Duel.GetMatchingGroup(nil,tp,LOCATION_MZONE,0,nil)
	local mg2=Duel.GetMatchingGroup(c4187.filter,tp,LOCATION_GRAVE,0,nil,tp)
	mg1:Merge(mg2)
	if chk==0 then return Duel.IsExistingMatchingCard(c4187.xyzfilter,tp,LOCATION_EXTRA,0,1,nil,mg1) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c4187.filter2(c,e,tp)
	return c:IsRelateToEffect(e) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c4187.operation(e,tp,eg,ep,ev,re,r,rp)
	local mg1=Duel.GetMatchingGroup(nil,tp,LOCATION_MZONE,0,nil)
	local mg2=Duel.GetMatchingGroup(c4187.filter,tp,LOCATION_GRAVE,0,nil,tp)
	mg1:Merge(mg2)
	local g=Duel.GetMatchingGroup(c4187.xyzfilter,tp,LOCATION_EXTRA,0,nil,mg1)
	if g:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local tg=g:Select(tp,1,1,nil)
		local tc=tg:GetFirst()
		--xyzmaterial
		local code=tc:GetOriginalCode()
		local mt=_G["c" .. code]
		local maxc=mt.xyz_count_max
		if not maxc or maxc>0 then
			maxc=mt.xyz_count
		end
		local g=Duel.SelectXyzMaterial(tp,tc,nil,tc:GetRank(),mt.xyz_count,maxc,mg1)
		Duel.XyzSummon(tp,tc,g)
	end
end
