--封印の黄金櫃
function c4249.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c4249.target)
	e1:SetOperation(c4249.activate)
	c:RegisterEffect(e1)
	--immune
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_IMMUNE_EFFECT)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_SZONE)
	e2:SetValue(c4249.efilter)
	c:RegisterEffect(e2)
	--remain field
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_REMAIN_FIELD)
	c:RegisterEffect(e3)
end
function c4249.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_DECK)
end
function c4249.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,Card.IsAbleToRemove,tp,LOCATION_HAND+LOCATION_DECK,0,1,1,nil)
	local tg=g:GetFirst()
	if tg==nil then return end
	Duel.Remove(tg,POS_FACEDOWN,REASON_EFFECT)
	local ac=tg:GetCode()
	----forbidden
	--local e1=Effect.CreateEffect(e:GetHandler())
	--e1:SetType(EFFECT_TYPE_FIELD)
	--e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	--e1:SetCode(EFFECT_FORBIDDEN)
	--e1:SetRange(LOCATION_SZONE)
	--e1:SetTargetRange(0x7f,0x7f)
	--e1:SetTarget(c4249.bantg)
	--e1:SetLabel(ac)
	--e1:SetReset(RESET_EVENT+0x1fe0000)
	--Duel.RegisterEffect(e1,c)
	
	--disable
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_DISABLE)
	e2:SetRange(LOCATION_SZONE)
	e2:SetLabel(ac)
	e2:SetTarget(c4249.distg)
	c:RegisterEffect(e2)
	--disable effect
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_CHAIN_SOLVING)
	e3:SetLabel(ac)
	e3:SetRange(LOCATION_SZONE)
	e3:SetOperation(c4249.disop)
	c:RegisterEffect(e3)
	
end
function c4249.bantg(e,c)
	return c:IsCode(e:GetLabel())
end
function c4249.efilter(e,te)
	return te:GetOwner()~=e:GetOwner()
end
function c4249.distg(e,c)
	return c:IsCode(e:GetLabel())
end
function c4249.disop(e,tp,eg,ep,ev,re,r,rp)
	local tl=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION)
	if re:GetHandler():IsCode(e:GetLabel()) then
		Duel.NegateEffect(ev)
	end
end
