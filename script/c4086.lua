--TGギア・ゾンビ
function c4086.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c4086.spcon)
	e1:SetOperation(c4086.spop)
	c:RegisterEffect(e1)
end
function c4086.spfilter(c)
	return c:IsSetCard(0x27) and c:GetAttack()>=1000 and c:IsFaceup()
end
function c4086.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c4086.spfilter,tp,LOCATION_MZONE,0,1,c)
end
function c4086.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=Duel.SelectMatchingCard(tp,c4086.spfilter,tp,LOCATION_MZONE,0,1,1,nil)
	local tc=g:GetFirst()
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_COPY_INHERIT)
		e1:SetReset(RESET_EVENT+0x1ff0000)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(-1000)
		tc:RegisterEffect(e1)
end
