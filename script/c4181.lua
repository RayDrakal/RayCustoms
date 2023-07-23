--CNo.107 超銀河眼の時空龍
function c4181.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,nil,9,3)
	c:EnableReviveLimit()
	--No
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e1:SetValue(c4181.indval)
	c:RegisterEffect(e1)
	--time tyrant
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(4181,0))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCost(c4181.negcost)
	e2:SetOperation(c4181.negop)
	c:RegisterEffect(e2)
	--107
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(4181,1))
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetCondition(c4181.atkcon)
	e3:SetCost(c4181.atkcost)
	e3:SetTarget(c4181.atktg)
	e3:SetOperation(c4181.atkop)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_MATERIAL_CHECK)
	e4:SetValue(c4181.valcheck)
	e4:SetLabelObject(e3)
	c:RegisterEffect(e4)
	--time tyrant check - turn start
	if not c4181.global_check then
		c4181.global_check=true
		--field
		c4181[0]=Group.CreateGroup()
		c4181[0]:KeepAlive()
		--field - location
		c4181[1]={}
		--field - face
		c4181[2]={}
		--hand
		c4181[3]=Group.CreateGroup()
		c4181[3]:KeepAlive()
		--hand - 
		c4181[4]={}
		--grave
		c4181[5]=Group.CreateGroup()
		c4181[5]:KeepAlive()
		--deck
		c4181[6]=Group.CreateGroup()
		c4181[6]:KeepAlive()
		--deck - 
		c4181[7]={}
		--ex deck
		c4181[8]=Group.CreateGroup()
		c4181[8]:KeepAlive()
		--ex deck - pendulum faceup
		c4181[9]={}
		--removed
		c4181[10]=Group.CreateGroup()
		c4181[10]:KeepAlive()
		--removed - facedown
		c4181[11]={}
		--overlay unit
		c4181[12]=Group.CreateGroup()
		c4181[12]:KeepAlive()
		--overlay unit - xyz
		c4181[13]=Group.CreateGroup()
		c4181[13]:KeepAlive()
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_PHASE_START+PHASE_DRAW)
		ge1:SetCountLimit(1,4181)
		ge1:SetOperation(c4181.tscheck)
		Duel.RegisterEffect(ge1,0)
	    --time tyrant check - activate
	    local ge2=Effect.CreateEffect(c)
		ge2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge2:SetCode(EVENT_CHAIN_SOLVED)
		ge2:SetOperation(c4181.accheck)
		Duel.RegisterEffect(ge2,0)
		--attack check
		local ge3=Effect.CreateEffect(c)
		ge3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge3:SetCode(EVENT_ATTACK_ANNOUNCE)
		ge3:SetOperation(c4181.atkcheck)
		Duel.RegisterEffect(ge3,0)
		local ge4=Effect.CreateEffect(c)
		ge4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge4:SetCode(EVENT_ATTACK_DISABLED)
		ge4:SetOperation(c4181.atkcheck2)
		Duel.RegisterEffect(ge4,0)
	end
end
c4181.xyz_number=107
function c4181.indval(e,c)
	return not c:IsSetCard(0x48)
end
function c4181.negcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c4181.filter(c)
	return c:IsFaceup() and (c:IsLocation(LOCATION_SZONE) or c:IsType(TYPE_EFFECT)) and not c:IsDisabled()
end
function c4181.negop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(c4181.filter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,c)
	local tc=g:GetFirst()
	while tc do
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e2)
		tc=g:GetNext()
	end
	--reset card
	local i=0
	--hand
	tc=c4181[3]:GetFirst()
	while tc do
		if tc~=e:GetHandler() and tc:GetFlagEffect(4181)~=0 then
			Duel.SendtoHand(tc,nil,2,REASON_EFFECT)
		end
		tc=c4181[3]:GetNext()
	end
	--grave
	tc=c4181[5]:GetFirst()
	while tc do
		if tc~=e:GetHandler() and tc:GetFlagEffect(4181)~=0 then
			Duel.SendtoGrave(tc,REASON_EFFECT)
		end
		tc=c4181[5]:GetNext()
	end
	--deck
	tc=c4181[6]:GetFirst()
	while tc do
		if tc~=e:GetHandler() and tc:GetFlagEffect(4181)~=0 then
			Duel.SendtoDeck(tc,nil,2,REASON_EFFECT)
		end
		tc=c4181[6]:GetNext()
	end
	--ex deck
	tc=c4181[8]:GetFirst()
	i=0
	while tc do
		if tc~=e:GetHandler() and tc:GetFlagEffect(4181)~=0 then
			if c4181[9][i+1] then
				Duel.SendtoExtraP(tc,tp,REASON_EFFECT)
			else
				Duel.SendtoDeck(tc,nil,2,REASON_EFFECT)
			end
			i=i+1
		end
		tc=c4181[8]:GetNext()
	end
	--removed
	tc=c4181[10]:GetFirst()
	i=0
	while tc do
		if tc~=e:GetHandler() and tc:GetFlagEffect(4181)~=0 then
			if c4181[11][i+1] then
				Duel.Remove(tc,POS_FACEDOWN,REASON_EFFECT)
			else
				Duel.Remove(tc,0,REASON_EFFECT)
			end
			i=i+1
		end
		tc=c4181[10]:GetNext()
	end
	--field
	tc=c4181[0]:GetFirst()
	i=0
	while tc do
		if tc~=e:GetHandler() and tc:GetFlagEffect(4181)~=0 then
			Duel.MoveToField(tc,tp,tp,c4181[1][i+1],c4181[2][i+1],true)
			i=i+1
		end
	tc=c4181[0]:GetNext()
	end
	--overlay
	tc=c4181[12]:GetFirst()
	local xtc=c4181[13]:GetFirst()
	while tc do
		if tc~=e:GetHandler() and tc:GetFlagEffect(4181)~=0 then
			Duel.Overlay(xtc,tc)
		end
		tc=c4181[12]:GetNext()
		xtc=c4181[13]:GetNext()
	end
	
	--negate
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_CHAINING)
	e3:SetCondition(c4181.negcon)
	e3:SetOperation(c4181.negop2)
	e3:SetTargetRange(1,0)
	e3:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e3,tp)
end
function c4181.negcon(e,tp,eg,ep,ev,re,r,rp)
	return re:GetHandler():IsOnField() and not re:GetHandler():IsImmuneToEffect(e) and Duel.IsChainNegatable(ev)
end
function c4181.negop2(e,tp,eg,ep,ev,re,r,rp)
	if Duel.SelectYesNo(tp,aux.Stringid(4181,2)) and re:GetHandler():IsRelateToEffect(re) then
		Duel.NegateActivation(ev)
	end
end
function c4181.atkcon(e,tp,eg,ep,ev,re,r,rp)
	return (Duel.IsAbleToEnterBP() or (Duel.GetCurrentPhase()>=PHASE_BATTLE_START and Duel.GetCurrentPhase()<=PHASE_BATTLE)) and e:GetLabel()==1
end
function c4181.costfilter(c)
	local ct=c:GetFlagEffectLabel(32391631)
	return (not ct or ct==0)
end
function c4181.atkcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroup(tp,c4181.costfilter,2,e:GetHandler()) end
	local g=Duel.SelectReleaseGroup(tp,c4181.costfilter,2,2,e:GetHandler())
	Duel.Release(g,REASON_COST)
end
function c4181.atktg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():GetEffectCount(EFFECT_EXTRA_ATTACK)==0 end
end
function c4181.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_EXTRA_ATTACK)
		e1:SetValue(2)
		e1:SetReset(RESET_EVENT+0x1ff0000+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e1)
	end
end
function c4181.xfilter(c)
	return c:IsCode(4180) and c:IsType(TYPE_XYZ) and c:IsRankBelow(8)
end
function c4181.valcheck(e,c)
	local g=c:GetMaterial()
	if g:IsExists(c4181.xfilter,1,nil) then
		e:GetLabelObject():SetLabel(1)
	else
		e:GetLabelObject():SetLabel(0)
	end
end
function c4181.tscheck(e,tp,eg,ep,ev,re,r,rp)
	--location check
	local tc=nil
	--field
	c4181[0]:Clear()
	c4181[1]={}
	c4181[2]={}
	local field=Duel.GetMatchingGroup(nil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	tc=field:GetFirst()
	while tc do
		if not c4181[0]:IsContains(tc) then
			c4181[0]:AddCard(tc)
			c4181[1][#c4181[1]+1]=tc:GetLocation()
			c4181[2][#c4181[2]+1]=tc:GetPosition()
		end
		tc=field:GetNext()
	end
	--hand
	c4181[3]:Clear()
	local hand=Duel.GetMatchingGroup(nil,tp,LOCATION_HAND,LOCATION_HAND,nil)
	tc=hand:GetFirst()
	while tc do
		if not c4181[3]:IsContains(tc) then
			c4181[3]:AddCard(tc)
		end
		tc=hand:GetNext()
	end
	--grave
	c4181[5]:Clear()
	local grave=Duel.GetMatchingGroup(nil,tp,LOCATION_GRAVE,LOCATION_GRAVE,nil)
	tc=grave:GetFirst()
	while tc do
		if not c4181[5]:IsContains(tc) then
			c4181[5]:AddCard(tc)
		end
		tc=grave:GetNext()
	end
	--deck
	c4181[6]:Clear()
	local deck=Duel.GetMatchingGroup(nil,tp,LOCATION_DECK,LOCATION_DECK,nil)
	tc=deck:GetFirst()
	while tc do
		if not c4181[6]:IsContains(tc) then
			c4181[6]:AddCard(tc)
		end
		tc=deck:GetNext()
	end
	--ex deck
	c4181[8]:Clear()
	c4181[9]={}
	local exdeck=Duel.GetMatchingGroup(nil,tp,LOCATION_EXTRA,LOCATION_EXTRA,nil)
	tc=exdeck:GetFirst()
	while tc do
		if not c4181[8]:IsContains(tc) then
			c4181[8]:AddCard(tc)
			c4181[9][#c4181[9]+1]=tc:IsFaceup()
		end
		tc=exdeck:GetNext()
	end
	--removed
	c4181[10]:Clear()
	c4181[11]={}
	local removed=Duel.GetMatchingGroup(nil,tp,LOCATION_REMOVED,LOCATION_REMOVED,nil)
	tc=removed:GetFirst()
	while tc do
		if not c4181[10]:IsContains(tc) then
			c4181[10]:AddCard(tc)
			c4181[11][#c4181[11]+1]=tc:IsFaceup()
		end
		tc=removed:GetNext()
	end
	--overlay unit
	c4181[12]:Clear()
	c4181[13]:Clear()
	local overlay=Duel.GetOverlayGroup(tp,1,1)
	tc=overlay:GetFirst()
	local xtc=nil
	while tc do
		xtc=tc:GetOverlayTarget()
		if not c4181[12]:IsContains(tc) then
			c4181[12]:AddCard(tc)
			c4181[13]:AddCard(xtc)
		end
		tc=overlay:GetNext()
	end
end
function c4181.accheck(e,tp,eg,ep,ev,re,r,rp)
	if re~=e:GetHandler() and re:GetHandler():GetFlagEffect(4181)==0  then
		re:GetHandler():RegisterFlagEffect(4181,RESET_PHASE+PHASE_END,0,1)
	end
end
function c4181.atkcheck(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	local ct=tc:GetFlagEffectLabel(32391631)
	if ct then
		tc:SetFlagEffectLabel(32391631,ct+1)
	else
		tc:RegisterFlagEffect(32391631,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1,1)
	end
end
function c4181.atkcheck2(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	local ct=tc:GetFlagEffectLabel(32391631)
	if ct then
		tc:SetFlagEffectLabel(32391631,ct-1)
	end
end
