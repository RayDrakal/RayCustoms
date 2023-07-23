--合神竜ティマイオス
function c3086.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcCode3(c,3083,3084,3085,true,true)
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	c:RegisterEffect(e1)
	--special summon rule
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_EXTRA)
	e2:SetCondition(c3086.sprcon)
	e2:SetOperation(c3086.sprop)
	c:RegisterEffect(e2)
	--immune
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_IMMUNE_EFFECT)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetValue(c3086.efilter)
	c:RegisterEffect(e3)
	--spsummon
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_DESTROYED)
	e4:SetTarget(c3086.sptg)
	e4:SetOperation(c3086.spop)
	c:RegisterEffect(e4)
	--infinity
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetCode(EFFECT_SET_ATTACK_FINAL)
	e5:SetDescription(aux.Stringid(3086,0))
	e5:SetProperty(EFFECT_FLAG_CLIENT_HINT)
	e5:SetValue(99999999)
	c:RegisterEffect(e5)
	local e6=e5:Clone()
	e6:SetCode(EFFECT_SET_DEFENSE_FINAL)
	c:RegisterEffect(e6)
	--indes
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_SINGLE)
	e7:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e7:SetValue(c3086.indes)
	c:RegisterEffect(e7)
	--infinity ilmit
	local e9=Effect.CreateEffect(c)
	e9:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e9:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e9:SetCode(EVENT_ADJUST)
	e9:SetRange(LOCATION_MZONE)
	e9:SetOperation(c3086.limit)
	c:RegisterEffect(e9)
end
function c3086.sprfilter(c,code)
	return c:IsCode(code) and c:IsAbleToGraveAsCost()
end
function c3086.sprcon(e,c)
	if c==nil then return true end 
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>-3
		and Duel.IsExistingMatchingCard(c3086.sprfilter,tp,LOCATION_ONFIELD,0,1,nil,3083)
		and Duel.IsExistingMatchingCard(c3086.sprfilter,tp,LOCATION_ONFIELD,0,1,nil,3084)
		and Duel.IsExistingMatchingCard(c3086.sprfilter,tp,LOCATION_ONFIELD,0,1,nil,3085)
end
function c3086.sprop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g1=Duel.SelectMatchingCard(tp,c3086.sprfilter,tp,LOCATION_ONFIELD,0,1,1,nil,3083)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g2=Duel.SelectMatchingCard(tp,c3086.sprfilter,tp,LOCATION_ONFIELD,0,1,1,nil,3084)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g3=Duel.SelectMatchingCard(tp,c3086.sprfilter,tp,LOCATION_ONFIELD,0,1,1,nil,3085)
	g1:Merge(g2)
	g1:Merge(g3)
	Duel.SendtoGrave(g1,REASON_COST)
end
function c3086.efilter(e,te)
	return te:GetOwner()~=e:GetOwner()
end
function c3086.spfilter(c,e,tp)
	return c:IsSetCard(0xa0) and c:IsCanBeSpecialSummoned(e,0,tp,true,true)
		and not c:IsHasEffect(EFFECT_NECRO_VALLEY)
end
function c3086.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>=3
		and Duel.IsExistingMatchingCard(c3086.spfilter,tp,0x13,0,3,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,3,tp,0x13)
end
function c3086.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<3 then return end
	local g=Duel.GetMatchingGroup(c3086.spfilter,tp,0x13,0,nil,e,tp)
	if g:GetCount()>2 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=g:Select(tp,3,3,nil)
		Duel.SpecialSummon(sg,0,tp,tp,true,true,POS_FACEUP)
	end
end
function c3086.indes(e,c)
	return c:GetAttack()>=99999999
end
function c3086.limfilter(c)
	return c:GetAttack()>99999999 or c:GetDefense()>99999999
end
function c3086.limcon(e)
	return e:GetHandler():GetAttack()>99999999
end
function c3086.limit(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c3086.limfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	local tc=g:GetFirst()
	while tc do
		if tc:GetAttack()>99999999 then
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UPDATE_ATTACK)
			e1:SetDescription(aux.Stringid(3086,0))
			e1:SetProperty(EFFECT_FLAG_CLIENT_HINT+EFFECT_FLAG_IGNORE_IMMUNE)
			e1:SetValue(99999999-tc:GetAttack())
			e1:SetReset(RESET_PHASE+0x3ff)
			tc:RegisterEffect(e1)
		end
		if tc:GetDefense()>99999999 then
			local e2=Effect.CreateEffect(e:GetHandler())
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_UPDATE_DEFENSE)
			e2:SetDescription(aux.Stringid(3086,0))
			e2:SetProperty(EFFECT_FLAG_CLIENT_HINT+EFFECT_FLAG_IGNORE_IMMUNE)
			e2:SetValue(99999999-tc:GetDefense())
			e2:SetReset(RESET_PHASE+0x3ff)
			tc:RegisterEffect(e2)
		end
		tc=g:GetNext()
	end
end
