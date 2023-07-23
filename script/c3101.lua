--オレイカルコス・キュトラー
function c3101.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c3101.spcon)
	e1:SetOperation(c3101.spop)
	c:RegisterEffect(e1)
    --Avoid Battle Damage
   	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EVENT_PRE_BATTLE_DAMAGE)
	e2:SetCondition(c3101.rdcon)
	e2:SetOperation(c3101.rdop)
	c:RegisterEffect(e2)
    --special summon s
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e3:SetCode(EVENT_DESTROYED)
	e3:SetTarget(c3101.target)
	e3:SetOperation(c3101.operation)
	e3:SetLabel(0)
	c:RegisterEffect(e3)
	e2:SetLabelObject(e3)
end
function c3101.spcon(e,c)
	if c==nil then return true end
	return Duel.CheckLPCost(c:GetControler(),500) and Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
end
function c3101.spop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.PayLPCost(tp,500)
end
function c3101.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c3101.filter,tp,LOCATION_DECK+LOCATION_HAND+LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK+LOCATION_HAND+LOCATION_GRAVE)
end
function c3101.filter(c,e,tp)
	return c:IsCode(3106) or c:IsCode(7634581) and c:IsCanBeSpecialSummoned(e,0,tp,true,true)
end
function c3101.operation(e,tp,eg,ep,ev,re,r,rp)
	local g1=Duel.GetMatchingGroup(c3101.filter,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,nil,e,tp)
	if g1:GetCount()>0  then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg1=g1:Select(tp,1,1,nil)
		local tc=sg1:GetFirst()
		if tc and Duel.SpecialSummonStep(tc,0,tp,tp,true,true,POS_FACEUP) then
			--attack up
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_SET_ATTACK)
			e1:SetValue(e:GetLabel())
			e1:SetReset(RESET_EVENT+0x1fe0000)
			tc:RegisterEffect(e1)				
			Duel.SpecialSummonComplete()
		end
		if e:GetLabel()>0 then
			e:SetLabel(0)
		end
	end
end
function c3101.rdcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetAttackTarget()~=nil and tp==ep
end
function c3101.rdop(e,tp,eg,ep,ev,re,r,rp)
	Duel.ChangeBattleDamage(tp,0)
	if ep==tp then
		local ev=e:GetLabelObject():GetLabel()+ev
		e:GetLabelObject():SetLabel(ev)
	end
end
