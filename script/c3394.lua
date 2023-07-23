--エクゾディア・ネクロス
function c3394.initial_effect(c)
	c:EnableReviveLimit()
	--cannot destroy
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(c3394.dcon1)
	e1:SetValue(1)
	c:RegisterEffect(e1)
	--monster
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c3394.dcon2)
	e2:SetValue(c3394.efdes2)
	c:RegisterEffect(e2)
	--trap
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(c3394.dcon3)
	e3:SetValue(c3394.efdes3)
	c:RegisterEffect(e3)
	--spell
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCondition(c3394.dcon4)
	e4:SetValue(c3394.efdes4)
	c:RegisterEffect(e4)
	--atkup
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(3394,0))
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e5:SetCategory(CATEGORY_ATKCHANGE)
	e5:SetCode(EVENT_DAMAGE_STEP_END)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCountLimit(1)
	e5:SetCondition(c3394.atkcon)
	e5:SetOperation(c3394.atkop)
	c:RegisterEffect(e5)
end
function c3394.efde2(e,re)
	return re:IsActiveType(TYPE_MONSTER)
end
function c3394.efdes3(e,re)
	return re:IsActiveType(TYPE_TRAP)
end
function c3394.efdes4(e,re)
	return re:IsActiveType(TYPE_SPELL)
end
function c3394.dcon1(e)
	local p=e:GetHandlerPlayer()
	return Duel.IsExistingMatchingCard(Card.IsCode,p,LOCATION_GRAVE,0,1,nil,33396948)
end
function c3394.dcon2(e)
	local p=e:GetHandlerPlayer()
	return Duel.IsExistingMatchingCard(Card.IsCode,p,LOCATION_GRAVE,0,1,nil,7902349)
end
function c3394.dcon3(e)
	local p=e:GetHandlerPlayer()
	return Duel.IsExistingMatchingCard(Card.IsCode,p,LOCATION_GRAVE,0,1,nil,8124921)
end
function c3394.dcon4(e)
	local p=e:GetHandlerPlayer()
	return Duel.IsExistingMatchingCard(Card.IsCode,p,LOCATION_GRAVE,0,1,nil,44519536)
end

function c3394.atkcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetAttacker()==e:GetHandler() and Duel.IsExistingMatchingCard(Card.IsCode,tp,LOCATION_GRAVE,0,1,nil,70903634)
end
function c3394.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsFaceup() and c:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(1000)
		e1:SetReset(RESET_EVENT+0x1ff0000)
		c:RegisterEffect(e1)
	end
end
