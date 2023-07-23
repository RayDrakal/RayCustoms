--オレイカルコス・シュノロス
function c3106.initial_effect(c)
	c:EnableReviveLimit()
	--sp
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(3106,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetTarget(c3106.sptg)
	e1:SetOperation(c3106.spop)
	c:RegisterEffect(e1)
	--cannot special summon
	local e2=Effect.CreateEffect(c)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_SPSUMMON_CONDITION)
	e2:SetValue(aux.FALSE)
	c:RegisterEffect(e2)
	--atk down
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_ATKCHANGE)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EVENT_DAMAGE_STEP_END)
	e3:SetCondition(c3106.adcon)
	e3:SetOperation(c3106.adop)
	c:RegisterEffect(e3)
	--Divine Serpent Geh
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(3106,1))
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e4:SetCode(EVENT_DESTROYED)
	e4:SetCost(c3106.gecost)
	e4:SetTarget(c3106.getg)
	e4:SetOperation(c3106.geop)
	c:RegisterEffect(e4)
	--cannot diratk
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetCode(EFFECT_CANNOT_DIRECT_ATTACK)
	c:RegisterEffect(e5)
	--selfdes
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e6:SetCode(EVENT_ADJUST)
	e6:SetRange(LOCATION_MZONE)
	e6:SetOperation(c3106.check)
	c:RegisterEffect(e6)
end
function c3106.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,2,tp,LOCATION_DECK+LOCATION_HAND+LOCATION_GRAVE)
end
function c3106.filter(c,e,tp,code)
	return c:IsCode(code) and c:IsCanBeSpecialSummoned(e,0,tp,true,true)
end
function c3106.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<2 then return end
	local g2=Duel.SelectMatchingCard(tp,c3106.filter,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,e,tp,3105)
	local g3=Duel.SelectMatchingCard(tp,c3106.filter,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,e,tp,3104)
	if g2:GetCount()>0 and g3:GetCount()>0 then
		Duel.SpecialSummon(g2,0,tp,tp,true,true,POS_FACEUP)
		Duel.SpecialSummon(g3,0,tp,tp,true,true,POS_FACEUP)
	end
end
function c3106.adop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local a=Duel.GetAttackTarget()
	if (a:GetControler()==tp and (a:IsCode(3105) or a:IsCode(3104) or a==e:GetHandler()))
	then
		a=Duel.GetAttacker()
	end
	if c:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(a:GetAttack()*-1)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		c:RegisterEffect(e1)
	end
end
function c3106.adcon(e,tp,eg,ep,ev,re,r,rp)
	local a=Duel.GetAttacker()
	local d=Duel.GetAttackTarget()
	return d~=nil and d:IsFaceup() and ((a:GetControler()==tp and (a:IsCode(3105) or a:IsCode(3104) or a==e:GetHandler())  and a:IsRelateToBattle())
		or (d:GetControler()==tp and (d:IsCode(3105) or d:IsCode(3104) or d==e:GetHandler()) and d:IsRelateToBattle()))
end
function c3106.spfilter(c,e,tp)
	return c:IsCode(3107) and c:IsCanBeSpecialSummoned(e,0,tp,true,true)
end
function c3106.gecost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local g=Duel.GetFieldGroup(tp,LOCATION_HAND,0)
		g:RemoveCard(e:GetHandler())
		return g:GetCount()>0 and g:FilterCount(Card.IsDiscardable,nil)==g:GetCount()
	end
	local g=Duel.GetFieldGroup(tp,LOCATION_HAND,0)
	Duel.SendtoGrave(g,REASON_COST+REASON_DISCARD)
	Duel.SetLP(tp,1,REASON_COST)
end
function c3106.getg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>=1
		and Duel.IsExistingMatchingCard(c3106.spfilter,tp,0x13,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,0x13)
end
function c3106.geop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<1 then return end
	local g=Duel.SelectMatchingCard(tp,c3106.spfilter,tp,0x13,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,true,true,POS_FACEUP)
	end
end
function c3106.check(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local atk=c:GetAttack()
	if c:GetFlagEffectLabel(3106)==nil then
		c:RegisterFlagEffect(3106,RESET_EVENT+0x1fe0000,0,1,atk)
		c:RegisterFlagEffect(3106+100000000,RESET_EVENT+0x1fe0000,0,1,0)
	else
		local flb1=c:GetFlagEffectLabel(3106)
		local flb2=c:GetFlagEffectLabel(3106+100000000)
		if flb1~=atk then
			c:SetFlagEffectLabel(3106,atk)
			if flb2==0 and atk==0 then
				Duel.Destroy(c,REASON_EFFECT)
			end
		end
	end
end
