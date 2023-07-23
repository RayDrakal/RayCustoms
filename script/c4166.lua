--RUM－七皇の剣
function c4166.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c4166.target)
	e1:SetOperation(c4166.activate)
	c:RegisterEffect(e1)
	--Barians Chaos Draw
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_PREDRAW)
		ge1:SetOperation(c4166.sdop)
		ge1:SetCountLimit(1,4166)
		ge1:SetCondition(c4166.sdcon)
		Duel.RegisterEffect(ge1,0)
end
function c4166.filter1(c,e,tp)
	local m=_G["c"..c:GetCode()]
	if not m then return false end
	local no=m.xyz_number
	local ect=c29724053 and Duel.IsPlayerAffectedByEffect(tp,29724053) and c29724053[tp]
	local rk=c:GetRank()
	return c:IsType(TYPE_XYZ) and (not ect or ect>1) and no and no>=101 and no<=107 and c:IsSetCard(0x48) and not c:IsSetCard(0x1048)
		and Duel.IsExistingMatchingCard(c4166.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,c,rk+1)
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,false,false)
end
function c4166.filter2(c,e,tp,mc,rk)
	return c:GetRank()==rk and (c:IsSetCard(0x1048) or c:IsSetCard(0x1073) or c:IsCode(4028)) and mc:IsCanBeXyzMaterial(c)
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,false,false)
end
function c4166.filter3(c,e,tp)
	local m=_G["c"..c:GetCode()]
	if not m then return false end
	local no=m.xyz_number
	return c:IsType(TYPE_XYZ) and no and no>=101 and no<=107 and c:IsSetCard(0x48) and not c:IsSetCard(0x1048)
	 and Duel.IsExistingMatchingCard(c4166.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,c,c:GetRank()+1)
end
function c4166.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and chkc:IsFaceup() end
	local b1=Duel.IsExistingMatchingCard(c4166.filter1,tp,LOCATION_GRAVE+LOCATION_EXTRA,0,1,nil,e,tp)
	local b2=Duel.IsExistingTarget(c4166.filter3,tp,LOCATION_MZONE,0,1,nil,e,tp)	
	if chk==0 then return (b1 and Duel.IsPlayerCanSpecialSummonCount(tp,2) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and 
	Duel.IsExistingMatchingCard(c4166.filter1,tp,LOCATION_GRAVE+LOCATION_EXTRA,0,1,nil,e,tp)) or b2 end
	local op=0
	if b1 and b2 then op=Duel.SelectOption(tp,aux.Stringid(4166,0),aux.Stringid(4166,1))
	elseif b1 then op=Duel.SelectOption(tp,aux.Stringid(4166,0))
	else op=Duel.SelectOption(tp,aux.Stringid(4166,1))+1 end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
	e:SetLabel(op)
	if op==1 then
		Duel.SelectTarget(tp,c4166.filter3,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
	end
end
function c4166.activate(e,tp,eg,ep,ev,re,r,rp)
	if e:GetLabel()==0 then
		if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local g1=Duel.SelectMatchingCard(tp,c4166.filter1,tp,LOCATION_GRAVE+LOCATION_EXTRA,0,1,1,nil,e,tp)
			local tc1=g1:GetFirst()
			if tc1 and not tc1:IsHasEffect(EFFECT_NECRO_VALLEY) and Duel.SpecialSummon(tc1,0,tp,tp,false,false,POS_FACEUP)~=0 then
				local m=_G["c"..tc1:GetCode()]
				if not m then return end
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
				local g2=Duel.SelectMatchingCard(tp,c4166.filter2,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,tc1,tc1:GetRank()+1)
				local tc2=g2:GetFirst()
					if tc2 then
						Duel.BreakEffect()
						tc2:SetMaterial(g1)
						Duel.Overlay(tc2,g1)
						Duel.SpecialSummon(tc2,SUMMON_TYPE_XYZ,tp,tp,false,false,POS_FACEUP)
						tc2:CompleteProcedure()
					end
				end
	else
		if Duel.GetLocationCount(tp,LOCATION_MZONE)<0 then return end
		local tc=Duel.GetFirstTarget()
		if tc:IsFacedown() or not tc:IsRelateToEffect(e) or tc:IsControler(1-tp) or tc:IsImmuneToEffect(e) then return end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,c4166.filter2,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,tc,tc:GetRank()+1)
		local sc=g:GetFirst()
		if sc then
			local mg=tc:GetOverlayGroup()
				if mg:GetCount()~=0 then
					Duel.Overlay(sc,mg)
				end
			sc:SetMaterial(Group.FromCards(tc))
			Duel.Overlay(sc,Group.FromCards(tc))
			Duel.SpecialSummon(sc,SUMMON_TYPE_XYZ,tp,tp,false,false,POS_FACEUP)
			sc:CompleteProcedure()
	end
				
	end
end
function c4166.sdop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler():GetOwner()
	if Duel.SelectYesNo(c,aux.Stringid(4166,2)) then
		Duel.Hint(HINT_MESSAGE,c,aux.Stringid(4166,3))
		Duel.MoveSequence(e:GetHandler(),0)
	end
end
function c4166.sdcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:GetOwner()==Duel.GetTurnPlayer() and Duel.GetTurnCount()~=1 and c:IsLocation(LOCATION_DECK)
end
