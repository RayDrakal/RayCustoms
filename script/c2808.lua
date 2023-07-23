--覇王眷竜オッドアイズ
function c2808.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c,true)
	--to P
	local e0=Effect.CreateEffect(c)
	e0:SetDescription(aux.Stringid(2800,0))
	e0:SetType(EFFECT_TYPE_IGNITION)
	e0:SetRange(LOCATION_PZONE)
	e0:SetCost(c2808.tcost)
	e0:SetOperation(c2808.top)
	c:RegisterEffect(e0)
	--Pendlulum
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetCondition(c2808.pcon)
	e1:SetCost(c2808.pcost)
	e1:SetTarget(c2808.ptg)
	e1:SetOperation(c2808.pop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetRange(LOCATION_DECK)
	c:RegisterEffect(e2)
	local e3=e1:Clone()
	e3:SetRange(LOCATION_HAND)
	c:RegisterEffect(e3)
	--at limit
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_CANNOT_SELECT_BATTLE_TARGET)
	e4:SetRange(LOCATION_MZONE)
	e4:SetTargetRange(0,LOCATION_MZONE)
	e4:SetValue(c2808.atlimit)
	c:RegisterEffect(e4)
	--special summon
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(2808,2))
	e5:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e5:SetType(EFFECT_TYPE_QUICK_O)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCode(EVENT_FREE_CHAIN)
	e5:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e5:SetCost(c2808.spcost)
	e5:SetTarget(c2808.sptg)
	e5:SetOperation(c2808.spop)
	c:RegisterEffect(e5)
	--battle damage
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e6:SetCode(EVENT_PRE_BATTLE_DAMAGE)
	e6:SetRange(LOCATION_MZONE)
	e6:SetCondition(c2808.rdcon)
	e6:SetOperation(c2808.rdop)
	c:RegisterEffect(e6)
	--
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_FIELD)
	e7:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e7:SetCode(EFFECT_INDESTRUCTABLE_COUNT)
	e7:SetRange(LOCATION_MZONE)
	e7:SetTargetRange(LOCATION_ONFIELD,LOCATION_ONFIELD)
	e7:SetTarget(c2808.indtg)
	e7:SetValue(c2808.indval)
	e7:SetCountLimit(1)
	c:RegisterEffect(e7)
end
function c2808.cfilter(c)
	return c:IsSetCard(507) or c:IsSetCard(0x21fb) or c:IsSetCard(0x11fb)
end
function c2808.tcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroup(tp,c2800.cfilter,1,nil) end
	local g=Duel.SelectReleaseGroup(tp,c2800.cfilter,1,1,nil)
	Duel.Release(g,REASON_COST)
end
function c2808.top(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.SendtoExtraP(c,nil,REASON_EFFECT)
end
function c2808.zfilter(c)
	return c:IsFaceup() and c:IsCode(2800)
end
function c2808.mfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x21fb) and c:IsReleasableByEffect()
end
function c2808.pfil(c)
	return c:GetSummonType()==SUMMON_TYPE_PENDULUM and c:IsType(TYPE_PENDULUM)
end
function c2808.pcon(e,tp,eg,ep,ev,re,r,rp)
	local tg=eg:GetFirst()
	return eg:IsExists(c2808.pfil,1,nil) and tp~=ep 
	and Duel.IsExistingMatchingCard(c2808.zfilter,tp,LOCATION_MZONE,0,1,nil)
	and Duel.CheckReleaseGroup(tp,c2808.mfilter,2,nil)
	and e:GetHandler():GetFlagEffect(2808)==0
end
function c2808.pcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	e:GetHandler():RegisterFlagEffect(2808,RESET_CHAIN,0,1)
end
function c2808.ptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
	and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,true,true) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,tp,e:GetHandler():GetLocation())
end
function c2808.pop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c and Duel.CheckReleaseGroup(tp,c2808.mfilter,2,nil) then
		local g=Duel.SelectReleaseGroup(tp,c2808.mfilter,2,2,nil)
		if g:GetCount()>1 then
			Duel.Release(g,REASON_EFFECT)
			Duel.SpecialSummon(c,0,tp,tp,true,true,POS_FACEUP)
		end
	end
end
function c2808.atlimit(e,c)
	return c~=e:GetHandler() and c:IsFaceup() and c:IsType(TYPE_PENDULUM)
end
function c2808.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return true end
	Duel.SendtoExtraP(c,nil,REASON_COST)
end
function c2808.spfilter(c,e,tp)
	return c:IsSetCard(0x21fb) and c:IsType(TYPE_PENDULUM) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c2808.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return not Duel.IsPlayerAffectedByEffect(tp,59822133)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c2808.spfilter,tp,LOCATION_EXTRA,0,2,c,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,2,tp,LOCATION_EXTRA)
end
function c2808.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then return end
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<2 then return end
	local g=Duel.GetMatchingGroup(c2808.spfilter,tp,LOCATION_EXTRA,0,c,e,tp)
	if g:GetCount()>=2 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=g:Select(tp,2,2,nil)
		if Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)==2 then
			local g2=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_MZONE,nil)
			if g2:GetCount()==0 then return end
			local tc=g2:GetFirst()
			while tc do
				local e1=Effect.CreateEffect(e:GetHandler())
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_SET_ATTACK_FINAL)
				e1:SetValue(0)
				e1:SetReset(RESET_EVENT+0x1fe0000)
				tc:RegisterEffect(e1)
				tc=g2:GetNext()
			end
		end		
	end
end
function c2808.rdcon(e,tp,eg,ep,ev,re,r,rp)
	local ac=eg:GetFirst()
	return ep~=tp and ac:IsControler(tp) and ac:IsType(TYPE_PENDULUM) and not ac:IsImmuneToEffect(e)
end
function c2808.rdop(e,tp,eg,ep,ev,re,r,rp)
	Duel.ChangeBattleDamage(ep,math.ceil(ev*2))
end
function c2808.indtg(e,c)
	return c:IsType(TYPE_PENDULUM)
end
function c2808.indval(e,re,r,rp)
	if bit.band(r,REASON_BATTLE+REASON_EFFECT)~=0 then
		return 1
	else return 0 end
end
