--ヌメロン・ストーム
function c4013.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c4013.target)
	e1:SetCondition(c4013.con)
	e1:SetOperation(c4013.activate)
	c:RegisterEffect(e1)
end
function c4013.filter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:GetSequence()<5
end
function c4013.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(c4013.filter,tp,0,LOCATION_SZONE,1,c) end
	local sg=Duel.GetMatchingGroup(c4013.filter,tp,0,LOCATION_SZONE,c)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,sg,sg:GetCount(),0,0)
	Duel.SetTargetPlayer(1-tp)
	Duel.SetTargetParam(1000)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,1000)
end
function c4013.activate(e,tp,eg,ep,ev,re,r,rp)
	local sg=Duel.GetMatchingGroup(c4013.filter,tp,0,LOCATION_SZONE,e:GetHandler())
	if Duel.Destroy(sg,REASON_EFFECT)~=0 then
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Damage(p,d,REASON_EFFECT)
	end
end
function c4013.con(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c4013.tfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c4013.tfilter(c,e,tp)
	return c:IsSetCard(0x268) and c:IsFaceup()
end
