--ＣｉＮｏ.１０００ 夢幻虚光神ヌメロニアス・ヌメロニア
function c4028.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,nil,13,5)
	c:EnableReviveLimit()
	--No
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e1:SetValue(c4028.indval)
	c:RegisterEffect(e1)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DAMAGE)
	e2:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_FIELD)
	e2:SetCode(EVENT_DESTROYED)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e2:SetRange(LOCATION_EXTRA)
	e2:SetCondition(c4028.spcon1)
	e2:SetTarget(c4028.sptg1)
	e2:SetOperation(c4028.spop1)
	c:RegisterEffect(e2)
	--indes
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e3:SetValue(1)
	c:RegisterEffect(e3)
	--cannot attack
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_CANNOT_ATTACK)
	c:RegisterEffect(e4)
	--cannot select battle target
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetRange(LOCATION_MZONE)
	e5:SetTargetRange(0,LOCATION_MZONE)
	e5:SetValue(c4028.atlimit)
	e5:SetCode(EFFECT_CANNOT_SELECT_BATTLE_TARGET)
	c:RegisterEffect(e5)
	--drain
	local e6=Effect.CreateEffect(c)
	e6:SetCategory(CATEGORY_RECOVER)
	e6:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e6:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e6:SetCode(EVENT_BE_BATTLE_TARGET)
	e6:SetCondition(c4028.condition)
	e6:SetTarget(c4028.target)
	e6:SetOperation(c4028.activate)
	e6:SetCost(c4028.cost)
	c:RegisterEffect(e6)
	--numeron
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e7:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e7:SetRange(LOCATION_MZONE)
	e7:SetCode(EVENT_PHASE+PHASE_END)
	e7:SetCountLimit(1)
	e7:SetCondition(c4028.nmcon)
	e7:SetOperation(c4028.nmop)
	c:RegisterEffect(e7)
	--check
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e8:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e8:SetCode(EVENT_PHASE+PHASE_BATTLE)
	e8:SetRange(LOCATION_MZONE)
	e8:SetCountLimit(1)
	e8:SetCondition(c4028.ccon)
	e8:SetOperation(c4028.cop)
	c:RegisterEffect(e8)
	local e9=Effect.CreateEffect(c)	
	e9:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e9:SetRange(LOCATION_MZONE)
	e9:SetCode(EVENT_ADJUST)
	e9:SetCountLimit(1)
	e9:SetCondition(c4028.ccon2)
	e9:SetOperation(c4028.cop2)
	c:RegisterEffect(e9)
end
function c4028.indval(e,c)
	return not c:IsSetCard(0x48)
end
function c4028.ovfilter(c,e)
	return c:IsLocation(LOCATION_GRAVE) and c:IsCode(89477759) and c:IsType(TYPE_XYZ) and c:IsCanBeEffectTarget(e)
end
function c4028.spcon1(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c4028.cfilter,1,nil,tp)
end
function c4028.spop1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,SUMMON_TYPE_XYZ,tp,tp,false,false,POS_FACEUP)~=0 then
		c:CompleteProcedure()
		local g=eg:Filter(c4028.ovfilter,nil,e)
		if g:GetCount()==0 then return end
		g=g:Select(tp,1,1,nil)
		local tc=g:GetFirst()
		Duel.Overlay(c,tc)
	end
end
function c4028.sptg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c4028.cfilter(c,tp)
	return c:IsReason(REASON_BATTLE+REASON_EFFECT) and c:IsCode(89477759)
		and c:IsPreviousLocation(LOCATION_MZONE) and c:IsPreviousPosition(POS_FACEUP) and c:GetPreviousControler()==tp
end
function c4028.atlimit(e,c)
	return c~=e:GetHandler()
end
function c4028.condition(e,tp,eg,ep,ev,re,r,rp)
	return tp~=Duel.GetTurnPlayer()
end
function c4028.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local tg=Duel.GetAttacker()
	if chkc then return chkc==tg end
	if chk==0 then return tg:IsOnField() and tg:IsCanBeEffectTarget(e) end
	Duel.SetTargetCard(tg)
	local rec=tg:GetAttack()
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,rec)
end
function c4028.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() and tc:IsAttackable() then
		if Duel.NegateAttack(tc) then
			Duel.Recover(tp,tc:GetAttack(),REASON_EFFECT)
		end
	end
end
function c4028.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c4028.nmcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=tp and e:GetHandler():GetFlagEffect(4028)~=0 and e:GetHandler():GetBattledGroupCount()==0
end
function c4028.nmop(e,tp,eg,ep,ev,re,r,rp)
	Duel.SetLP(1-tp,0,REASON_RULE)
end
function c4028.ccon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=tp
end
function c4028.cop(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():RegisterFlagEffect(4028,RESET_PHASE+PHASE_END,0,1)
end
function c4028.ccon2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=tp
end
function c4028.cop2(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():RegisterFlagEffect(4028,RESET_PHASE+PHASE_END,0,1)
end
