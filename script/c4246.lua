--真青眼の究極竜
function c4246.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcCodeRep(c,89631139,3,true,true)
	--extra attack
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,4246+EFFECT_COUNT_CODE_DUEL)
	e1:SetCondition(c4246.atkcon)
	e1:SetOperation(c4246.atkop)
	c:RegisterEffect(e1)
	--self destroy
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_BATTLED)
	e2:SetOperation(c4246.seldes)
	c:RegisterEffect(e2)
	--immune effect
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_IMMUNE_EFFECT)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetTargetRange(LOCATION_MZONE,0)
	e3:SetTarget(c4246.etarget)
	e3:SetValue(c4246.efilter)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e4:SetValue(aux.tgval)
	c:RegisterEffect(e4)
	----???
		--local ge1=Effect.CreateEffect(c)
		--ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		--ge1:SetCode(EVENT_PREDRAW)
		--ge1:SetOperation(c4246.sdop)
		--ge1:SetCountLimit(1,4246)
		--ge1:SetCondition(c4246.sdcon)
		--Duel.RegisterEffect(ge1,0)
end
function c4246.etarget(e,c)
	return c:IsCode(23995346)
end
function c4246.etarget2(c)
	return c:IsCode(23995346)
end
function c4246.efilter(e,te)
	return te:GetOwner()~=e:GetOwner()
end
function c4246.atkcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsAbleToEnterBP() and Duel.IsExistingMatchingCard(c4246.etarget2,tp,LOCATION_EXTRA,0,1,nil,tp)
end
function c4246.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local cg=Duel.SelectMatchingCard(tp,c4246.etarget2,tp,LOCATION_EXTRA,0,1,1,nil,tp)
	if cg:GetCount()==0 then return end
	Duel.ConfirmCards(1-tp,cg)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCode(EFFECT_EXTRA_ATTACK)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		e1:SetValue(2)
		c:RegisterEffect(e1)
end
function c4246.seldes(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.RegisterFlagEffect(c,4246,RESET_PHASE+PHASE_END,0,1)
	local ct=Duel.GetFlagEffect(c,4246)
	if ct==3 then
	Duel.Destroy(c,REASON_EFFECT)
	end
end
function c4246.sdop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler():GetOwner()
	if Duel.SelectYesNo(c,aux.Stringid(4246,0)) then
	Duel.Hint(HINT_MESSAGE,c,aux.Stringid(4246,2))
	local token=Duel.CreateToken(c,3271,nil,nil,nil,nil,nil,nil)	
	if token then
		Duel.SendtoDeck(token,nil,0,REASON_RULE)
		e:GetHandler():RegisterFlagEffect(4246,0,0,1)
	end
	end
end
function c4246.sdcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:GetOwner()==Duel.GetTurnPlayer() and Duel.GetTurnCount()~=1 and e:GetHandler():GetFlagEffect(4246)==0
end
