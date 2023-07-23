--ダブルフィン・シャーク
function c4184.initial_effect(c)
	--xyz summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_ADJUST)
	e1:SetRange(LOCATION_MZONE)	
	e1:SetOperation(c4184.op)
	c:RegisterEffect(e1)
	--
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(4184)
	c:RegisterEffect(e2)
end
function c4184.filterx(c)
	return c:IsAttribute(ATTRIBUTE_WATER) and c:IsType(TYPE_XYZ) and c.xyz_count and c.xyz_count>0
end
function c4184.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(c4184.filterx,c:GetControler(),LOCATION_EXTRA,LOCATION_EXTRA,nil)
	local tc=g:GetFirst()
	while tc do
		local tck=Duel.CreateToken(tp,4184)
		if tc:GetFlagEffect(4184)==0 then
			local e1=Effect.CreateEffect(tc)
			e1:SetType(EFFECT_TYPE_FIELD)
			e1:SetDescription(aux.Stringid(4184,0))
			e1:SetCode(EFFECT_SPSUMMON_PROC)
			e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
			e1:SetRange(LOCATION_EXTRA)
			e1:SetValue(SUMMON_TYPE_XYZ)
			e1:SetCondition(c4184.xyzcon)
			e1:SetOperation(c4184.xyzop)
			e1:SetLabelObject(tck)
			e1:SetReset(RESET_EVENT+EVENT_ADJUST)
			tc:RegisterEffect(e1)
			tc:RegisterFlagEffect(4184,RESET_EVENT+EVENT_ADJUST,0,1) 	
		end
		tc=g:GetNext()
	end
end
function c4184.doublefilter(c,rk,xyz)
	local code=xyz:GetOriginalCode()
	local mt=_G["c" .. code]
	return c:IsFaceup() and c:IsCanBeXyzMaterial(xyz) and c:IsXyzLevel(xyz,rk) and c:IsType(TYPE_MONSTER)
	and c:IsHasEffect(4184) and not c:IsType(TYPE_XYZ) and (not mt.f or mt.f(c))
end
function c4184.notgafilter(c,rk,xyz)
	local code=xyz:GetOriginalCode()
	local mt=_G["c" .. code]
	return c:IsFaceup() and c:IsCanBeXyzMaterial(xyz) and c:IsXyzLevel(xyz,rk) and c:IsType(TYPE_MONSTER)
	and not c:IsHasEffect(4184) and not c:IsType(TYPE_XYZ) and (not mt.f or mt.f(c))
end
function c4184.xyzcon(e,c,og)
	if c==nil then return true end
	local tp=c:GetControler()
	local rk=c:GetRank()
	local ct=c.xyz_count
	local mg=Duel.GetMatchingGroup(c4184.doublefilter,tp,LOCATION_ONFIELD,0,nil,rk,c)
	local mg2=Duel.GetMatchingGroup(c4184.notgafilter,tp,LOCATION_ONFIELD,0,nil,rk,c)
	return mg:GetCount()>0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>-1 and mg:GetCount()*2+mg2:GetCount()>=ct
end
function c4184.xyzop(e,tp,eg,ep,ev,re,r,rp,c,og)
	local c=e:GetHandler()
	local rk=c:GetRank()
	local ct=c.xyz_count
	local mg=Duel.GetMatchingGroup(c4184.doublefilter,tp,LOCATION_ONFIELD,0,nil,rk,c)
	local mg2=Duel.GetMatchingGroup(c4184.notgafilter,tp,LOCATION_ONFIELD,0,nil,rk,c)
	mg:Merge(mg2)
	local g1=Group.CreateGroup()
	g1:KeepAlive()
	while ct>0 do
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
		local gc=mg:Select(tp,1,1,nil):GetFirst()
		g1:AddCard(gc)
		mg:RemoveCard(gc)
		if gc:IsHasEffect(4184) then
			if gc:IsHasEffect(4184) and (mg:GetCount()<=1 or Duel.SelectYesNo(tp,aux.Stringid(4184,1)))  then
				ct=ct-1
			end
		end
		ct=ct-1
	end
	local sg=Group.CreateGroup()
	local tc=g1:GetFirst()
	while tc do
		local sg1=tc:GetOverlayGroup()
		sg:Merge(sg1)
		tc=g1:GetNext()
	end
	Duel.SendtoGrave(sg,REASON_RULE)
	c:SetMaterial(g1)
	Duel.Overlay(c,g1)
end
function c4184.effectcon(e)
	local c=e:GetHandler()
	return c:GetFlagEffect(4184)==0 or c:IsHasEffect(EFFECT_CANNOT_DISABLE)
end
