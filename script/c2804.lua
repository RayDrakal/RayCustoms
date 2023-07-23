--”e‰¤–å–³ŒÀ
function c2804.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--zero
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(2804)
	e1:SetRange(LOCATION_PZONE)
	e1:SetTargetRange(LOCATION_ONFIELD,0)
	e1:SetTarget(aux.TargetBoolFunction(Card.IsCode,2803))
	c:RegisterEffect(e1)
	--selfdes
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetCode(EFFECT_SELF_DESTROY)
	e3:SetRange(LOCATION_PZONE)
	e3:SetCondition(c2804.descon)
	c:RegisterEffect(e3)
	--
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_DESTROY)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_DESTROYED)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetCondition(c2804.pencon)
	e4:SetTarget(c2804.pentg)
	e4:SetOperation(c2804.penop)
	c:RegisterEffect(e4)
end
function c2804.cfilter(c)
	return c:IsFaceup() and (c:IsSetCard(507) or c:IsSetCard(0x21fb) or c:IsSetCard(0x11fb))
end
function c2804.damcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:GetFlagEffect(2804)==0 or c:IsHasEffect(EFFECT_CANNOT_DISABLE)
end
function c2804.cfilter(c)
	return c:IsCode(2803)
end
function c2804.descon(e)
    return not Duel.IsExistingMatchingCard(c2804.cfilter,tp,LOCATION_PZONE,0,1,e:GetHandler())
end
function c2804.thfilter(c)
	return c:IsCode(2803) and c:IsAbleToHand()
end
function c2804.pencon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return bit.band(r,REASON_EFFECT+REASON_BATTLE)~=0 and c:IsPreviousLocation(LOCATION_MZONE) and c:IsFaceup()
end
function c2804.pentg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c2804.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c2804.penop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c2804.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
