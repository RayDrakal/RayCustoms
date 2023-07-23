--剣闘獣総監エーディトル
function c4122.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFunRep(c,c4122.matfilter,2,true)
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(c4122.splimit)
	c:RegisterEffect(e1)
	--special summon rule
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(4122,0))
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_EXTRA)
	e2:SetCondition(c4122.sprcon)
	e2:SetOperation(c4122.sprop)
	c:RegisterEffect(e2)
	--extra summon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(4122,1))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetTarget(c4122.esptg)
	e3:SetOperation(c4122.espop)
	c:RegisterEffect(e3)
	--destroy
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(4122,2))
	e4:SetCategory(CATEGORY_DESTROY)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_MZONE)
	e4:SetProperty(EFFECT_FLAG_BOTH_SIDE)
	e4:SetCountLimit(1)
	e4:SetTarget(c4122.destg)
	e4:SetOperation(c4122.desop)
	c:RegisterEffect(e4)
	--negate attack
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e5:SetProperty(EFFECT_FLAG_DELAY)
	e5:SetCode(EVENT_BE_BATTLE_TARGET)
	e5:SetOperation(c4122.operation)
	c:RegisterEffect(e5)
	--special summon
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(4122,3))
	e6:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e6:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e6:SetCode(EVENT_PHASE+PHASE_BATTLE)
	e6:SetRange(LOCATION_MZONE)
	e6:SetCountLimit(1)
	e6:SetCondition(c4122.spcon)
	e6:SetCost(c4122.spcost)
	e6:SetTarget(c4122.sptg)
	e6:SetOperation(c4122.spop)
	c:RegisterEffect(e6)
	if not c4122.global_check then
		c4122.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_BATTLE_START)
		ge1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		ge1:SetOperation(c4122.check)
		Duel.RegisterEffect(ge1,0)
	end
end
function c4122.splimit(e,se,sp,st)
	return e:GetHandler():GetLocation()~=LOCATION_EXTRA
end
function c4122.matfilter(c)
	return c:IsLevelAbove(5) and c:IsFusionSetCard(0x19)
end
function c4122.sprcon(e,c)
	if c==nil then return true end 
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>-2
		and Duel.IsExistingMatchingCard(c4122.matfilter,tp,LOCATION_ONFIELD,0,2,nil,tp)
end
function c4122.sprop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(4122,2))
	local g1=Duel.SelectMatchingCard(tp,c4122.matfilter,tp,LOCATION_ONFIELD,0,2,2,nil,tp)
	local tc=g1:GetFirst()
	while tc do
		if not tc:IsFaceup() then Duel.ConfirmCards(1-tp,tc) end
		tc=g1:GetNext()
	end
	Duel.SendtoDeck(g1,nil,2,REASON_COST)
end
function c4122.espfilter(c,e,tp)
	return c:IsSetCard(0x19) and c:IsType(TYPE_FUSION)
		and c:IsCanBeSpecialSummoned(e,123,tp,true,false)
end
function c4122.esptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c4122.espop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetFieldGroup(tp,LOCATION_EXTRA,LOCATION_EXTRA)
	Duel.ConfirmCards(tp,g)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local g=Duel.SelectMatchingCard(tp,c4122.espfilter,tp,LOCATION_EXTRA,LOCATION_EXTRA,1,1,nil,e,tp)
		if g:GetCount()>0 then
			Duel.SpecialSummon(g:GetFirst(),123,tp,g:GetFirst():GetControler(),true,false,POS_FACEUP_ATTACK)
		end
end
function c4122.gfilter(c,e,tp)
	return c:IsSetCard(0x19) and c:IsType(TYPE_MONSTER)
		and c:IsFaceup()
end
function c4122.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c4122.gfilter,Duel.GetTurnPlayer(),LOCATION_MZONE,0,1,nil)
	and Duel.IsExistingMatchingCard(c4122.gfilter,Duel.GetTurnPlayer(),LOCATION_MZONE,LOCATION_MZONE,2,nil) end
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c4122.desop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectMatchingCard(tp,aux.TRUE,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	if g:GetCount()>0 then
		Duel.BreakEffect()
		Duel.HintSelection(g)
		local p=g:GetFirst():GetControler()
		local dam=g:GetFirst():GetAttack()
		if Duel.Destroy(g,REASON_EFFECT)~=0 then		
			Duel.Damage(p,dam,REASON_EFFECT)
		end
	end
end
function c4122.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateAttack()
end
function c4122.bfilter(c,e,tp)
	return c:IsSetCard(0x19) and (c:IsAbleToExtraAsCost() or c:IsAbleToDeckAsCost()) and c:IsType(TYPE_MONSTER) and c:IsFaceup()
end
function c4122.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(tp,4122)~=0
end
function c4122.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local g=Duel.SelectMatchingCard(tp,c4122.bfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SendtoDeck(g,nil,0,REASON_COST)
end
function c4122.filter(c,e,tp)
	return c:IsSetCard(0x19) and c:IsCanBeSpecialSummoned(e,122,tp,false,false)
end
function c4122.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not Duel.IsPlayerAffectedByEffect(tp,59822133)
		and Duel.IsExistingMatchingCard(c4122.filter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c4122.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<1 then return end
	local g=Duel.GetMatchingGroup(c4122.filter,tp,LOCATION_DECK,0,nil,e,tp)
	if g:GetCount()>=1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=g:Select(tp,1,1,nil)
		local tc=sg:GetFirst()
		Duel.SpecialSummonStep(tc,122,tp,tp,false,false,POS_FACEUP)
		tc:RegisterFlagEffect(tc:GetOriginalCode(),RESET_EVENT+0x1ff0000,0,0)
		Duel.SpecialSummonComplete()
	end
end
function c4122.check(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetAttacker()
	local tc2=Duel.GetAttackTarget()
	if (tc and not tc:IsRelateToBattle()) and (tc2 and not tc2:IsRelateToBattle()) then return end
	if tc:IsSetCard(0x19) or (tc2 and tc2:IsSetCard(0x19)) then
		local p=e:GetHandler():GetControler()
		Duel.RegisterFlagEffect(p,4122,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1)
	end
end
