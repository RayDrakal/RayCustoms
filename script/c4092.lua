--集いし願い
function c4092.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_BATTLE_START)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e1:SetHintTiming(TIMING_DAMAGE_STEP)
	e1:SetCondition(c4092.atkcon)
	e1:SetOperation(c4092.atkop)
	c:RegisterEffect(e1)
	--battle
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCondition(c4092.bcon)
	e2:SetCost(c4092.bcost)
	e2:SetOperation(c4092.bop)
	c:RegisterEffect(e2)
	--remove
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(4092,1))
	e3:SetCategory(CATEGORY_REMOVE)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(EVENT_PHASE+PHASE_END)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCountLimit(1)
	e3:SetTarget(c4092.destg)
	e3:SetOperation(c4092.desop)
	c:RegisterEffect(e3)
end
function c4092.atkcon(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetAttacker()
	local bc=Duel.GetAttackTarget()
	if not bc then return false end
	if tc:IsControler(1-tp) then tc,bc=bc,tc end
	e:SetLabelObject(tc)
	local batk=bc:GetAttack()
	local tatk=tc:GetAttack()
	return bc:IsFaceup() and tc:IsFaceup() and (tatk<batk) and tc:IsType(TYPE_SYNCHRO) and tc:IsRace(RACE_DRAGON) and (tc:IsSetCard(0xa3) or tc:IsLevelAbove(10))
end
function c4092.filter1(c,e,tp)
	return c:IsCode(44508094) and Duel.IsExistingMatchingCard(c4092.filter2,tp,LOCATION_GRAVE,0,1,nil,tp,8)
end
function c4092.filter2(c,tp,lv)
	local rlv=lv-c:GetLevel()
	local rg=Duel.GetMatchingGroup(c4092.filter3,tp,LOCATION_GRAVE,0,c)
	return rlv>0 and c:IsType(TYPE_TUNER) and c:IsAbleToRemove()
		and rg:CheckWithSumEqual(Card.GetLevel,rlv,1,63)
end
function c4092.filter3(c)
	return c:GetLevel()>0 and not c:IsType(TYPE_TUNER) and c:IsAbleToRemove()
end
function c4092.atkop(e,tp,eg,ep,ev,re,r,rp)
		local tc=e:GetLabelObject()
		local c=e:GetHandler()
		if Duel.Destroy(tc,REASON_RULE) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c4092.filter1,tp,LOCATION_EXTRA,0,1,nil,e,tp)
		and Duel.SelectYesNo(tp,aux.Stringid(4092,0)) then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g1=Duel.SelectMatchingCard(tp,c4092.filter1,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
		local lv=g1:GetFirst():GetLevel()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local g2=Duel.SelectMatchingCard(tp,c4092.filter2,tp,LOCATION_GRAVE,0,1,1,nil,tp,lv)
		local rlv=lv-g2:GetFirst():GetLevel()
		local rg=Duel.GetMatchingGroup(c4092.filter3,tp,LOCATION_GRAVE,0,g2:GetFirst())
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local g3=rg:SelectWithSumEqual(tp,Card.GetLevel,rlv,1,63)
		g2:Merge(g3)
		Duel.Remove(g2,POS_FACEUP,REASON_EFFECT)
		Duel.SpecialSummon(g1,SUMMON_TYPE_SYNCHRO,tp,tp,false,false,POS_FACEUP)
		c:SetCardTarget(g1:GetFirst())
		g1:GetFirst():CompleteProcedure()
		g1:GetFirst():RegisterFlagEffect(4092,RESET_EVENT+0x1fe0000,0,0)
		c:CreateRelation(g1:GetFirst(),RESET_EVENT+0x1020000)
		--atkup
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		e1:SetRange(LOCATION_MZONE)
		e1:SetValue(c4092.val)
		g1:GetFirst():RegisterEffect(e1)
	end
end
function c4092.afilter(c)
	return c:IsType(TYPE_SYNCHRO) and c:IsRace(RACE_DRAGON)
end
function c4092.val(e,c)
	local tc=Duel.GetMatchingGroup(c4092.afilter,c:GetControler(),LOCATION_GRAVE,0,nil)
	return tc:GetSum(Card.GetAttack)
end
function c4092.bcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()==PHASE_BATTLE_STEP  and Duel.IsExistingMatchingCard(c4092.atkfilter,tp,0,LOCATION_MZONE,1,nil) and Duel.IsExistingMatchingCard(c4092.atkfilter2,tp,LOCATION_MZONE,0,1,nil)
end
function c4092.tdfilter(c)
	return c:IsType(TYPE_SYNCHRO) and c:IsAbleToDeck()
end
function c4092.bcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c4092.tdfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,c4092.tdfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SendtoDeck(g,nil,2,REASON_COST)
end
function c4092.atkfilter(c)
	return c:IsPosition(POS_FACEUP_ATTACK)
end
function c4092.atkfilter2(c)
	return c:IsPosition(POS_FACEUP_ATTACK) and c:IsCode(44508094)
end
function c4092.bop(e,tp,eg,ep,ev,re,r,rp)
	local sg1=Duel.SelectMatchingCard(tp,c4092.atkfilter,tp,0,LOCATION_MZONE,1,1,nil)
	local sg2=Duel.SelectMatchingCard(tp,c4092.atkfilter2,tp,LOCATION_MZONE,0,1,1,nil)
	local c1=sg1:GetFirst()
	local c2=sg2:GetFirst()
		if c1:IsPosition(POS_FACEUP_ATTACK) and c2:IsPosition(POS_FACEUP_ATTACK) then
			Duel.CalculateDamage(c2,c1,true)
		end
end
function c4092.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local dg=Duel.GetMatchingGroup(c4092.desfilter,tp,LOCATION_MZONE,0,nil,e:GetHandler())
	dg:AddCard(e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,dg,1,0,0)
end
function c4092.desfilter(c,rc)
	return (c:GetFlagEffect(4092)~=0 and rc:IsRelateToCard(c))
end
function c4092.desop(e,tp,eg,ep,ev,re,r,rp)
	local dg=Duel.GetMatchingGroup(c4092.desfilter,tp,LOCATION_MZONE,0,nil,e:GetHandler())
	dg:AddCard(e:GetHandler())
	Duel.Remove(dg,POS_FACEUP,REASON_EFFECT)
end
