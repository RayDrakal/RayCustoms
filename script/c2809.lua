--覇王眷竜スターヴヴェノム
function c2809.initial_effect(c)
	--fusion summon
	aux.AddFusionProcFunRep(c,c2809.ffilter,2,false)
	c:EnableReviveLimit()
	--FUSION
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetCondition(c2809.fuscon)
	e1:SetCost(c2809.fuscost)
	e1:SetTarget(c2809.fustg)
	e1:SetOperation(c2809.fusop)
	c:RegisterEffect(e1)
	--at limit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_SELECT_BATTLE_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(0,LOCATION_MZONE)
	e2:SetValue(c2809.atlimit)
	c:RegisterEffect(e2)
	--special summon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(2809,2))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e3:SetCost(c2809.spcost)
	e3:SetTarget(c2809.sptg)
	e3:SetOperation(c2809.spop)
	c:RegisterEffect(e3)
	--pierce
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_PIERCE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetTargetRange(LOCATION_MZONE,0)
	c:RegisterEffect(e4)
	--copy
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(2809,0))
	e5:SetType(EFFECT_TYPE_QUICK_O)
	e5:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCode(EVENT_FREE_CHAIN)
	e5:SetCountLimit(1)
	e5:SetCondition(c2809.condition)
	e5:SetCost(c2809.cost)
	e5:SetTarget(c2809.target)
	e5:SetOperation(c2809.operation)
	c:RegisterEffect(e5)
	--copy2
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(2809,0))
	e6:SetType(EFFECT_TYPE_QUICK_O)
	e6:SetRange(LOCATION_MZONE)
	e6:SetCode(EVENT_FREE_CHAIN)
	e6:SetCountLimit(1)
	e6:SetCondition(c2809.condition2)
	e6:SetCost(c2809.cost)
	e6:SetTarget(c2809.target2)
	e6:SetOperation(c2809.operation2)
	c:RegisterEffect(e6)
end
function c2809.ffilter(c)
	return c:IsAttribute(ATTRIBUTE_DARK)
end
function c2809.zfilter(c)
	return c:IsFaceup() and c:IsCode(2800)
end
function c2809.mfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x21fb) and c:IsReleasableByEffect()
end
function c2809.fuscon(e,tp,eg,ep,ev,re,r,rp)
	local tg=eg:GetFirst()
	return eg:GetCount()==1 and tp~=ep and tg:GetSummonType()==SUMMON_TYPE_FUSION
	and Duel.IsExistingMatchingCard(c2809.zfilter,tp,LOCATION_MZONE,0,1,nil)
	and Duel.CheckReleaseGroup(tp,c2809.mfilter,2,nil)
	and e:GetHandler():GetFlagEffect(2809)==0
end
function c2809.fuscost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	e:GetHandler():RegisterFlagEffect(2809,RESET_CHAIN,0,1)
end
function c2809.fustg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
	and e:GetHandler():IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,true,true) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,tp,LOCATION_EXTRA)
end
function c2809.fusop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c and Duel.CheckReleaseGroup(tp,c2809.mfilter,2,nil) then
		local g=Duel.SelectReleaseGroup(tp,c2809.mfilter,2,2,nil)
		if g:GetCount()>1 then
			Duel.Release(g,REASON_EFFECT)
			Duel.SpecialSummon(c,SUMMON_TYPE_FUSION,tp,tp,true,true,POS_FACEUP)
			c:CompleteProcedure()
		end
	end
end
function c2809.atlimit(e,c)
	return c~=e:GetHandler() and c:IsFaceup() and c:IsType(TYPE_FUSION)
end
function c2809.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToExtraAsCost() end
	Duel.SendtoDeck(c,nil,0,REASON_COST)
end
function c2809.spfilter(c,e,tp)
	return c:IsSetCard(0x21fb) and c:IsType(TYPE_PENDULUM) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c2809.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not Duel.IsPlayerAffectedByEffect(tp,59822133)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c2809.spfilter,tp,LOCATION_EXTRA,0,2,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,2,tp,LOCATION_EXTRA)
end
function c2809.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then return end
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<2 then return end
	local g=Duel.GetMatchingGroup(c2809.spfilter,tp,LOCATION_EXTRA,0,nil,e,tp)
	if g:GetCount()>=2 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=g:Select(tp,2,2,nil)
		if Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)==2 then
			local g2=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_MZONE,nil)
			if g2:GetCount()==0 then return end
			local tc=g2:GetFirst()
			while tc do
				if tc:IsType(TYPE_FUSION) then
					local e1=Effect.CreateEffect(e:GetHandler())
					e1:SetType(EFFECT_TYPE_SINGLE)
					e1:SetCode(EFFECT_SET_ATTACK_FINAL)
					e1:SetValue(0)
					e1:SetReset(RESET_EVENT+0x1fe0000)
					tc:RegisterEffect(e1)
				end
				tc=g2:GetNext()
			end
		end		
	end
end
function c2809.condition(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	return Duel.GetTurnPlayer()==tp and (ph==PHASE_MAIN1 or ph==PHASE_MAIN2 or (ph>=PHASE_BATTLE_START and ph<=PHASE_BATTLE))
	and not e:GetHandler():IsHasEffect(2810)
end
function c2809.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:GetFlagEffect(2809)==0 end
	c:RegisterFlagEffect(2809,RESET_PHASE+PHASE_END,0,1)
end
function c2809.copyfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_MONSTER)
end
function c2809.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(0x14) and chkc:IsControler(tp) and c2809.copyfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c2809.copyfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,LOCATION_MZONE+LOCATION_GRAVE,1,nil) end
	local g=Duel.SelectTarget(tp,c2809.copyfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,LOCATION_MZONE+LOCATION_GRAVE,1,1,nil)
end
function c2809.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc and c:IsRelateToEffect(e) and c:IsFaceup() and tc:IsRelateToEffect(e) and not tc:IsType(TYPE_TOKEN) then
		local code=tc:GetOriginalCode()
		local cid=0
		if not tc:IsType(TYPE_TRAPMONSTER) then
			cid=c:CopyEffect(code,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,1)
		end
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_SINGLE)
		e3:SetCode(EFFECT_DISABLE)
		e3:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e3)
		local e4=Effect.CreateEffect(c)
		e4:SetType(EFFECT_TYPE_SINGLE)
		e4:SetCode(EFFECT_DISABLE_EFFECT)
		e4:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e4)
	end
end
function c2809.condition2(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	return Duel.GetTurnPlayer()==tp and (ph==PHASE_MAIN1 or ph==PHASE_MAIN2 or (ph>=PHASE_BATTLE_START and ph<=PHASE_BATTLE))
	and e:GetHandler():IsHasEffect(2810)
end
function c2809.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingTarget(c2809.copyfilter,tp,0,LOCATION_MZONE,1,nil) end
end
function c2809.operation2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(c2809.copyfilter,tp,0,LOCATION_MZONE,nil)
	local tc=g:GetFirst()
	while tc do
		if tc and c:IsRelateToEffect(e) and c:IsFaceup() and not tc:IsType(TYPE_TOKEN) then
			local code=tc:GetOriginalCode()
			local cid=0
			if not tc:IsType(TYPE_TRAPMONSTER) then
				cid=c:CopyEffect(code,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,1)
			end
			local e3=Effect.CreateEffect(c)
			e3:SetType(EFFECT_TYPE_SINGLE)
			e3:SetCode(EFFECT_DISABLE)
			e3:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
			tc:RegisterEffect(e3)
			local e4=Effect.CreateEffect(c)
			e4:SetType(EFFECT_TYPE_SINGLE)
			e4:SetCode(EFFECT_DISABLE_EFFECT)
			e4:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
			tc:RegisterEffect(e4)
		end
		tc=g:GetNext()
	end
end
