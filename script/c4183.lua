--オーバーハンドレッド・カオス・ユニバース
function c4183.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c4183.target)
	e1:SetOperation(c4183.activate)
	c:RegisterEffect(e1)
end
function c4183.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 
		and Duel.IsExistingMatchingCard(c4183.filter,tp,LOCATION_GRAVE,0,1,nil,e,tp,Duel.GetTurnCount()) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end
function c4183.filter(c,e,tp,id)
	local m=_G["c"..c:GetCode()]
	if not m then return false end
	local no=m.xyz_number
	return c:IsReason(REASON_DESTROY) and c:IsSetCard(0x1048) and no>=101 and no<=107 and c:GetTurnID()==id and c:IsCanBeSpecialSummoned(e,0,tp,true,true)
end
function c4183.spfilter(c,e,tp)
	local m=_G["c"..c:GetCode()]
	if not m then return false end
	local no=m.xyz_number
	return c:IsSetCard(0x1048) and no>=101 and no<=107 and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c4183.activate(e,tp,eg,ep,ev,re,r,rp)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local tg=Duel.GetMatchingGroup(c4183.filter,tp,LOCATION_GRAVE,0,nil,e,tp,Duel.GetTurnCount())
	if ft<=0 then return end
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then ft=1 end
	local g=nil
	if tg:GetCount()>ft then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		g=tg:Select(tp,ft,ft,nil)
	else
		g=tg
	end
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,true,true,POS_FACEUP)
		local g2=Duel.GetMatchingGroup(c4183.spfilter,tp,LOCATION_EXTRA,0,nil,e,tp)
		local ft2=Duel.GetLocationCount(1-tp,LOCATION_MZONE)
		if g:GetCount()>0 and ft2>0 and Duel.SelectYesNo(tp,aux.Stringid(4183,1)) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			g3=g2:Select(tp,1,g:GetCount(),nil)
			Duel.SpecialSummon(g3,0,tp,1-tp,false,false,POS_FACEUP)
		end
		g:Merge(g3)
		local tc=g:GetFirst()
		local c=e:GetHandler()
		while tc do
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_DISABLE)
			e1:SetReset(RESET_EVENT+0x1fe0000)
			tc:RegisterEffect(e1)
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_DISABLE_EFFECT)
			e2:SetReset(RESET_EVENT+0x1fe0000)
			tc:RegisterEffect(e2)
			tc=g:GetNext()
		end
	end
end
