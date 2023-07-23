--黄泉天輪
function c3071.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1)
	e1:SetTarget(c3071.atarget)
	e1:SetOperation(c3071.activate)
	c:RegisterEffect(e1)
	--Special Summon
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetHintTiming(0,TIMING_END_PHASE)
	e2:SetRange(LOCATION_SZONE)
	e2:SetProperty(EFFECT_FLAG_BOTH_SIDE+EFFECT_FLAG_CARD_TARGET)
	e2:SetCost(c3071.cost)
	e2:SetCondition(c3071.condition)
	e2:SetTarget(c3071.target)
	e2:SetOperation(c3071.operation)
	c:RegisterEffect(e2)
	--
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetCode(3071)
	e3:SetRange(LOCATION_SZONE)
	e3:SetTargetRange(1,1)
	e3:SetValue(1)
	c:RegisterEffect(e3)
	--Ignoring the Summoning conditions
	local cs=Card.IsCanBeSpecialSummoned
	Card.IsCanBeSpecialSummoned=function(c,e,tpe,tp,con,limit)
		if Duel.IsPlayerAffectedByEffect(tp,3071) and c:IsType(TYPE_MONSTER) then return cs(c,e,tpe,tp,true,true)
		else return cs(c,e,tpe,tp,con,limit)
		end
	end
	local sp=Duel.SpecialSummon
	Duel.SpecialSummon=function(g,tpe,sump,tp,check,limit,pos)
		if Duel.IsPlayerAffectedByEffect(tp,3071) then return sp(g,tpe,sump,tp,true,true,pos)
		else return sp(g,tpe,sump,tp,check,limit,pos)
		end
	end
	local sps=Duel.SpecialSummonStep
	Duel.SpecialSummonStep=function(tc,tpe,sump,tp,check,limit,pos)
		if Duel.IsPlayerAffectedByEffect(tp,3071) then return sps(tc,tpe,sump,tp,true,true,pos)
		else return sp(tc,tpe,sump,tp,check,limit,pos)
		end
	end
end
function c3071.rfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsAbleToRemove()
end
function c3071.condition(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetFlagEffect(3071+tp)==0
end
function c3071.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	e:GetHandler():RegisterFlagEffect(3071+tp,RESET_EVENT+0x47e0000+RESET_PHASE+PHASE_END,0,1)
end
function c3071.atarget(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local sg=Duel.GetMatchingGroup(Card.IsDestructable,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,sg,sg:GetCount(),0,0)
end
function c3071.activate(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local sg=Duel.GetMatchingGroup(Card.IsDestructable,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	Duel.Destroy(sg,REASON_EFFECT)
	local sd=Duel.GetMatchingGroup(c3071.rfilter,tp,LOCATION_DECK,LOCATION_DECK,nil)
	Duel.Remove(sd,POS_FACEUP,REASON_EFFECT)
end
function c3071.filter(c,e,tp)
	return c:IsType(TYPE_MONSTER) and c:IsCanBeSpecialSummoned(e,0,tp,true,true)
end
function c3071.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c3071.filter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c3071.filter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c3071.filter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c3071.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and e:GetHandler():IsRelateToEffect(e) then
		if 	Duel.SpecialSummon(tc,0,tp,tp,true,true,POS_FACEUP) then
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetReset(RESET_EVENT+0x47e0000)
			e1:SetValue(LOCATION_REMOVED)
			tc:RegisterEffect(e1,true)
		end
	end
end
