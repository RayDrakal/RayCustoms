--幻魔の扉
function c3384.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c3384.target)
	e1:SetOperation(c3384.activate)
	c:RegisterEffect(e1)
	--summon check
	if not c3384.global_check then
		c3384.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_SUMMON_SUCCESS)
		ge1:SetOperation(c3384.checkop)
		Duel.RegisterEffect(ge1,0)
		local ge2=ge1:Clone()
		ge2:SetCode(EVENT_SPSUMMON_SUCCESS)
		Duel.RegisterEffect(ge2,0)
	end
end
function c3384.checkop(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	while tc do
			tc:RegisterFlagEffect(3384,0,0,1)
		tc=eg:GetNext()
	end
end
function c3384.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local sg=Duel.GetMatchingGroup(Card.IsDestructable,tp,0,LOCATION_MZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,sg,sg:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
function c3384.spfilter(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,true,true) and c:IsType(TYPE_MONSTER) and c:GetFlagEffect(3384)~=0
end
function c3384.activate(e,tp,eg,ep,ev,re,r,rp)
	local sg=Duel.GetMatchingGroup(Card.IsDestructable,tp,0,LOCATION_MZONE,nil)
	Duel.Destroy(sg,REASON_EFFECT)
	local tg=Duel.GetFieldGroup(tp,0,LOCATION_EXTRA+LOCATION_DECK)
	Duel.ConfirmCards(tp,tg)
	local g1=Duel.SelectMatchingCard(tp,c3384.spfilter,tp,0,LOCATION_GRAVE+LOCATION_DECK+LOCATION_EXTRA,1,1,nil,e,tp)
	local tc=g1:GetFirst()
	if tc then Duel.SpecialSummon(tc,0,tp,tp,true,true,POS_FACEUP) end
end
