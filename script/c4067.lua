--ワイゼルＣ
function c4067.initial_effect(c)
	--selfdes
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetCode(EFFECT_SELF_DESTROY)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(c4067.descon)
	c:RegisterEffect(e1)
	--indes
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e2:SetRange(LOCATION_MZONE)
	e2:SetValue(c4067.indval)
	c:RegisterEffect(e2)
end
function c4067.sdfilter(c)
	return c:IsFaceup() and (c:IsSetCard(0x3013) or c:IsCode(4050,63468625))
end
function c4067.descon(e)
	return not Duel.IsExistingMatchingCard(c4067.sdfilter,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil)
end
function c4067.indval(e,re,tp)
	return tp~=e:GetHandlerPlayer()
end
