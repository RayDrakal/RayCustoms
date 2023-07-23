--アーマード・グラビテーション
function c3127.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c3127.target)
	e1:SetOperation(c3127.activate)
	c:RegisterEffect(e1)
end
function c3127.spfilter(c,e,tp)
	return c:IsLevelBelow(4) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
		and c:IsCode(3115,3116,3117,3118,3119,3120,3121,3122,3123,3124,3125,3126)
end
function c3127.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c3127.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c3127.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if ft<=0 then return end
	if ft>2 then ft=4 end
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then ft=1 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c3127.spfilter,tp,LOCATION_DECK,0,1,ft,nil,e,tp)
	local fid=c:GetFieldID()
	local tc=g:GetFirst()
		while tc do
			Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP_ATTACK)
			tc:RegisterFlagEffect(3127,RESET_EVENT+0x1fe0000,0,1,fid)
			tc=g:GetNext()
		end
	g:KeepAlive()
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_PHASE+PHASE_END)
	e3:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e3:SetCountLimit(1)
	e3:SetLabel(fid)
	e3:SetLabelObject(g)
	e3:SetCondition(c3127.descon)
	e3:SetOperation(c3127.desop)
	Duel.RegisterEffect(e3,tp)
	Duel.SpecialSummonComplete()
end
function c3127.desfilter(c,fid)
	return c:GetFlagEffectLabel(3127)==fid
end
function c3127.descon(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetLabelObject()
	if not g:IsExists(c3127.desfilter,1,nil,e:GetLabel()) then
		g:DeleteGroup()
		e:Reset()
		return false
	else return true end
end
function c3127.desop(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetLabelObject()
	local tg=g:Filter(c3127.desfilter,nil,e:GetLabel())
	Duel.SendtoGrave(tg,REASON_EFFECT)
end
