--スキエルＴ
function c4063.initial_effect(c)
	--selfdes
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetCode(EFFECT_SELF_DESTROY)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(c4063.descon)
	c:RegisterEffect(e1)
end
function c4063.sdfilter(c)
	return c:IsFaceup() and (c:IsSetCard(0x3013) or c:IsCode(4050,63468625))
end
function c4063.descon(e)
	return not Duel.IsExistingMatchingCard(c4063.sdfilter,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil)
end
