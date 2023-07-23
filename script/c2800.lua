--覇王龍ズァーク
function c2800.initial_effect(c)
	c:EnableReviveLimit()
	--pendulum summon
	aux.EnablePendulumAttribute(c,false)
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	c:RegisterEffect(e1)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(2800,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_PZONE)
	e2:SetCost(c2800.spcost)
	e2:SetTarget(c2800.sptg)
	e2:SetOperation(c2800.spop)
	c:RegisterEffect(e2)
	--destroy
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_DESTROY+CATEGORY_DAMAGE)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetCost(c2800.descost)
	e3:SetTarget(c2800.destg)
	e3:SetOperation(c2800.desop)
	c:RegisterEffect(e3)
	--indestructable
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e4:SetCondition(c2800.indcon)
	e4:SetValue(1)
	c:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	c:RegisterEffect(e5)
	--immune
	local e6=e4:Clone()
	e6:SetCode(EFFECT_CANNOT_CHANGE_CONTROL)
	e6:SetValue(c2800.efilter)
	c:RegisterEffect(e6)
	local e7=e6:Clone()
	e7:SetCode(EFFECT_CANNOT_TO_DECK)
	c:RegisterEffect(e7)
	local e8=e6:Clone()
	e8:SetCode(EFFECT_CANNOT_TO_HAND)
	c:RegisterEffect(e8)
	local e9=e6:Clone()
	e9:SetCode(EFFECT_CANNOT_REMOVE)
	c:RegisterEffect(e9)
	local e10=e6:Clone()
	e10:SetCode(EFFECT_CANNOT_TO_GRAVE)
	c:RegisterEffect(e10)
	local e11=e6:Clone()
	e11:SetCode(EFFECT_UNRELEASABLE_EFFECT)
	c:RegisterEffect(e11)
	local e16=e6:Clone()
	e11:SetCode(EFFECT_CANNOT_BE_FUSION_MATERIAL)
	c:RegisterEffect(e16)
	--immune
	local e12=Effect.CreateEffect(c)
	e12:SetType(EFFECT_TYPE_FIELD)
	e12:SetCode(EFFECT_IMMUNE_EFFECT)
	e12:SetRange(LOCATION_MZONE)
	e12:SetTargetRange(LOCATION_MZONE,0)
	e12:SetValue(c2800.ifilter)
	c:RegisterEffect(e12)
	--spsummon
	local e13=Effect.CreateEffect(c)
	e13:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e13:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e13:SetCode(EVENT_BATTLE_DESTROYING)
	e13:SetCondition(aux.bdocon)
	e13:SetTarget(c2800.bdtg)
	e13:SetOperation(c2800.bdop)
	c:RegisterEffect(e13)
	--hand destroy
	local e14=Effect.CreateEffect(c)
	e14:SetCategory(CATEGORY_DESTROY)
	e14:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e14:SetCode(EVENT_TO_HAND)
	e14:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e14:SetRange(LOCATION_MZONE)
	e14:SetCondition(c2800.handcon)
	e14:SetTarget(c2800.handtg)
	e14:SetOperation(c2800.handop)
	c:RegisterEffect(e14)
	--xyz lv
	local e15=Effect.CreateEffect(c)
	e15:SetType(EFFECT_TYPE_SINGLE)
	e15:SetCode(EFFECT_XYZ_LEVEL)
	e15:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e15:SetValue(c2800.xyzlv)
	c:RegisterEffect(e15)
	--add code
	local e17=Effect.CreateEffect(c)
	e17:SetType(EFFECT_TYPE_SINGLE)
	e17:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e17:SetCode(EFFECT_ADD_CODE)
	e17:SetValue(13331639)
	c:RegisterEffect(e17)
end
function c2800.cfilter(c)
	return c:IsSetCard(507) or c:IsSetCard(0x21fb) or c:IsSetCard(0x11fb)
end
function c2800.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroup(tp,c2800.cfilter,1,nil) end
	local g=Duel.SelectReleaseGroup(tp,c2800.cfilter,1,1,nil)
	Duel.Release(g,REASON_COST)
end
function c2800.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,true,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c2800.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	if Duel.SpecialSummon(c,0,tp,tp,true,false,POS_FACEUP)==0 and Duel.GetLocationCount(tp,LOCATION_MZONE)<=0
		and c:IsCanBeSpecialSummoned(e,0,tp,true,false) then
		Duel.SendtoGrave(c,REASON_RULE)
	end
end
function c2800.descost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():GetAttackAnnouncedCount()==0 end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CANNOT_ATTACK)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_OATH)
	e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
	e:GetHandler():RegisterEffect(e1)
end
function c2800.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(aux.TRUE,tp,0,LOCATION_MZONE,1,nil) end
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_MZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,g:GetSum(Card.GetAttack))
end
function c2800.desop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_MZONE,nil)
	local tc=g:GetFirst()
	local atk=0
	while tc do
		local tatk=tc:GetAttack()
		if Duel.Destroy(tc,REASON_EFFECT)~=0 and tatk>0 then atk=atk+tatk end
		tc=g:GetNext()
	end
	Duel.BreakEffect()
	Duel.Damage(1-tp,atk,REASON_EFFECT)
end
function c2800.indfilter(c)
	return c:IsFaceup() and bit.band(c:GetType(),TYPE_FUSION+TYPE_SYNCHRO+TYPE_XYZ)~=0
end
function c2800.indcon(e)
	return Duel.IsExistingMatchingCard(c2800.indfilter,e:GetHandlerPlayer(),LOCATION_GRAVE+LOCATION_REMOVED,LOCATION_GRAVE+LOCATION_REMOVED,1,nil)
end
function c2800.efilter(e,re,tp)
	return tp~=e:GetHandlerPlayer()
end
function c2800.ifilter(e,re)
	return re:GetOwnerPlayer()~=e:GetHandlerPlayer() and re:GetOwner():IsType(TYPE_FUSION+TYPE_SYNCHRO+TYPE_XYZ)
end
function c2800.bdfilter(c,e,tp)
	return c:IsSetCard(0x21fb) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c2800.bdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
	and Duel.IsExistingMatchingCard(c2800.bdfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c2800.bdop(e,tp,eg,ep,ev,re,r,rp)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if ft<=0 then return end
	if ft>2 then ft=2 end
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then ft=1 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c2800.bdfilter,tp,LOCATION_EXTRA,0,1,ft,nil,e,tp)
	if g:GetCount()~=0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP_DEFENSE)
	end
end
function c2800.handfilter(c,tp)
	return c:IsControler(tp) and not c:IsPreviousLocation(LOCATION_HAND)
end
function c2800.handcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()~=PHASE_DRAW and eg:IsExists(c2800.handfilter,1,nil,1-tp)
end
function c2800.handtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local ct=eg:FilterCount(c2800.handfilter,nil,1-tp)
	Duel.SetTargetCard(eg)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,ct,1-tp,LOCATION_HAND)
end
function c2800.handop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local g=eg:Filter(c2800.handfilter,nil,1-tp):Filter(Card.IsRelateToEffect,nil,e)
	if g:GetCount()>0 then
		Duel.Destroy(g,REASON_EFFECT)
	end
end
function c2800.xyzlv(e,c,rc)
	return c:GetRank()
end
