--覇王眷竜クリアウィング
function c2807.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,aux.FilterBoolFunction(Card.IsAttribute,ATTRIBUTE_DARK),aux.NonTuner(nil),1)
	c:EnableReviveLimit()
	--SYNCHRO
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetCondition(c2807.syncon)
	e1:SetCost(c2807.syncost)
	e1:SetTarget(c2807.syntg)
	e1:SetOperation(c2807.synop)
	c:RegisterEffect(e1)
	local e7=e1:Clone()
	e7:SetRange(LOCATION_GRAVE)
	c:RegisterEffect(e7)
	--at limit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_SELECT_BATTLE_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(0,LOCATION_MZONE)
	e2:SetValue(c2807.atlimit)
	c:RegisterEffect(e2)
	--destroy
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(2807,0))
	e3:SetCategory(CATEGORY_DESTROY+CATEGORY_DAMAGE)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetTarget(c2807.destg)
	e3:SetOperation(c2807.desop)
	c:RegisterEffect(e3)
	--special summon
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(2807,2))
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e4:SetCost(c2807.spcost)
	e4:SetTarget(c2807.sptg)
	e4:SetOperation(c2807.spop)
	c:RegisterEffect(e4)
	--battle
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(2807,1))
	e5:SetCategory(CATEGORY_ATKCHANGE)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e5:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCountLimit(1)
	e5:SetCode(EVENT_ATTACK_ANNOUNCE)
	e5:SetCondition(c2807.atkcon)
	e5:SetTarget(c2807.target)
	e5:SetOperation(c2807.atkop)
	c:RegisterEffect(e5)
	--battle2
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(2807,1))
	e6:SetCategory(CATEGORY_ATKCHANGE)
	e6:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e6:SetRange(LOCATION_MZONE)
	e6:SetCode(EVENT_ATTACK_ANNOUNCE)
	e6:SetCondition(c2807.atkcon2)
	e6:SetTarget(c2807.target2)
	e6:SetOperation(c2807.atkop2)
	c:RegisterEffect(e6)
end
function c2807.zfilter(c)
	return c:IsFaceup() and c:IsCode(2800)
end
function c2807.mfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x21fb) and c:IsReleasableByEffect()
end
function c2807.syncon(e,tp,eg,ep,ev,re,r,rp)
	local tg=eg:GetFirst()
	return eg:GetCount()==1 and tp~=ep and tg:GetSummonType()==SUMMON_TYPE_SYNCHRO
	and Duel.IsExistingMatchingCard(c2807.zfilter,tp,LOCATION_MZONE,0,1,nil)
	and Duel.CheckReleaseGroup(tp,c2807.mfilter,2,nil)
	and e:GetHandler():GetFlagEffect(2807)==0
end
function c2807.syncost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	e:GetHandler():RegisterFlagEffect(2807,RESET_CHAIN,0,1)
end
function c2807.syntg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
	and e:GetHandler():IsCanBeSpecialSummoned(e,SUMMON_TYPE_SYNCHRO,tp,true,true) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,tp,LOCATION_EXTRA)
end
function c2807.synop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c and Duel.CheckReleaseGroup(tp,c2807.mfilter,2,nil) then
		local g=Duel.SelectReleaseGroup(tp,c2807.mfilter,2,2,nil)
		if g:GetCount()>1 then
			Duel.Release(g,REASON_EFFECT)
			Duel.SpecialSummon(c,SUMMON_TYPE_SYNCHRO,tp,tp,true,true,POS_FACEUP)
			c:CompleteProcedure()
		end
	end
end
function c2807.atlimit(e,c)
	return c~=e:GetHandler() and c:IsFaceup() and c:IsType(TYPE_SYNCHRO)
end
function c2807.desfilter(c)
	return c:IsFaceup()
end
function c2807.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c2807.desfilter,tp,0,LOCATION_MZONE,1,nil) end
	local g=Duel.GetMatchingGroup(c2807.desfilter,tp,0,LOCATION_MZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c2807.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(c2807.desfilter,tp,0,LOCATION_MZONE,nil)
	local tc=g:GetFirst()
	while tc do
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e2)
		if tc:IsType(TYPE_TRAPMONSTER) then
			local e3=Effect.CreateEffect(c)
			e3:SetType(EFFECT_TYPE_SINGLE)
			e3:SetCode(EFFECT_DISABLE_TRAPMONSTER)
			e3:SetReset(RESET_EVENT+0x1fe0000)
			tc:RegisterEffect(e3)
		end
		Duel.AdjustInstantly()
		Duel.NegateRelatedChain(tc,RESET_TURN_SET)
		tc=g:GetNext()
	end
	Duel.Destroy(g,REASON_EFFECT)
end
function c2807.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	local c=e:GetHandler()
	local bc=c:GetBattleTarget()
	if chk==0 then return bc and bc:IsOnField() and bc:IsCanBeEffectTarget(e) end
	Duel.SetTargetCard(bc)
end
function c2807.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToExtraAsCost() end
	Duel.SendtoDeck(c,nil,0,REASON_COST)
end
function c2807.spfilter(c,e,tp)
	return c:IsSetCard(0x21fb) and c:IsType(TYPE_PENDULUM) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c2807.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not Duel.IsPlayerAffectedByEffect(tp,59822133)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c2807.spfilter,tp,LOCATION_EXTRA,0,2,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,2,tp,LOCATION_EXTRA)
end
function c2807.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then return end
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<2 then return end
	local g=Duel.GetMatchingGroup(c2807.spfilter,tp,LOCATION_EXTRA,0,nil,e,tp)
	if g:GetCount()>=2 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=g:Select(tp,2,2,nil)
		if Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)==2 then
			local g2=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_MZONE,nil)
			if g2:GetCount()==0 then return end
			local tc=g2:GetFirst()
			while tc do
				if tc:IsType(TYPE_SYNCHRO) then
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
function c2807.atkcon(e,tp,eg,ep,ev,re,r,rp)
	return ((e:GetHandler()==Duel.GetAttacker() and Duel.GetAttackTarget()~=nil) or e:GetHandler()==Duel.GetAttackTarget())
	and not e:GetHandler():IsHasEffect(2810)
end
function c2807.atkcon2(e,tp,eg,ep,ev,re,r,rp)
	return ((e:GetHandler()==Duel.GetAttacker() and Duel.GetAttackTarget()~=nil) or e:GetHandler()==Duel.GetAttackTarget())
	and e:GetHandler():IsHasEffect(2810)
end
function c2807.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	local c=e:GetHandler()
	local bc=c:GetBattleTarget()
	if chk==0 then return bc and bc:IsOnField() and bc:IsCanBeEffectTarget(e) end
	Duel.SetTargetCard(bc)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,bc,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,bc:GetAttack())
end
function c2807.target2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	local c=e:GetHandler()
	local bc=c:GetBattleTarget()
	if chk==0 then return bc and bc:IsOnField() end
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_MZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,g:GetSum(Card.GetAttack))
end
function c2807.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local bc=c:GetBattleTarget()
	if bc:IsRelateToBattle() and Duel.NegateAttack() then
		local atk=bc:GetAttack()
		if Duel.Destroy(bc,REASON_EFFECT)~=0 and atk>0 then
			Duel.Damage(1-tp,atk,REASON_EFFECT)
		end
	end
end
function c2807.atkop2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local bc=c:GetBattleTarget()
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_MZONE,nil)
	local tc=g:GetFirst()
	local atk=0
	if bc:IsRelateToBattle() and Duel.NegateAttack() then
	while tc do
		local tatk=tc:GetAttack()
		if Duel.Destroy(tc,REASON_EFFECT)~=0 and tatk>0 then atk=atk+tatk end
		tc=g:GetNext()
	end
	Duel.Damage(1-tp,atk,REASON_EFFECT)
	end
end
