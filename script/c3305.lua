--アカシックレコード
function c3305.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c3305.target)
	e1:SetOperation(c3305.activate)
	c:RegisterEffect(e1)
	if not c3305.globle_check then
		c3305.globle_check=true
		c3305[1]=Group.CreateGroup()
		c3305[1]:KeepAlive()
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
		ge1:SetCode(EVENT_SUMMON_SUCCESS)
		ge1:SetOperation(c3305.checkop)
		Duel.RegisterEffect(ge1,0)
		local ge2=ge1:Clone()
		ge2:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
		Duel.RegisterEffect(ge2,0)
		local ge3=ge1:Clone()
		ge3:SetCode(EVENT_SPSUMMON_SUCCESS)
		Duel.RegisterEffect(ge3,0)
		local ge4=ge1:Clone()
		ge4:SetCode(EVENT_FLIP)
		Duel.RegisterEffect(ge4,0)
		local ge5=ge1:Clone()
		ge5:SetCode(EVENT_CHAINING)
		Duel.RegisterEffect(ge5,0)
	end
end
function c3305.filter(c)
	return c3305[1]:IsExists(Card.IsCode,1,c,c:GetCode())
end
function c3305.checkop(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	while tc do
			if not c3305[1]:IsContains(tc) then c3305[1]:AddCard(tc)
			end
		tc=eg:GetNext()
	end
end
function c3305.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,2) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(2)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,2)
end
function c3305.activate(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
	local g=Duel.GetOperatedGroup()
	Duel.ConfirmCards(1-p,g)
	local dg=g:Filter(c3305.filter,nil,e,tp)
	Duel.Remove(dg,POS_FACEUP,REASON_EFFECT)
end
