--神秘のモノリス
function c3336.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(3336)
	e2:SetCondition(c3336.effectcon)
	c:RegisterEffect(e2)
	--xyz summon
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_ADJUST)
	e3:SetRange(LOCATION_SZONE)	
	e3:SetOperation(c3336.op)
	c:RegisterEffect(e3)
end
c3336.xyzsub=4
function c3336.filterx(c,mg)
	return c:IsType(TYPE_XYZ) and c.xyz_count and c.xyz_count>0
end
function c3336.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(c3336.filterx,c:GetControler(),LOCATION_EXTRA,LOCATION_EXTRA,nil)
	local tc=g:GetFirst()
	while tc do
		local tck=Duel.CreateToken(tp,3336)
		if tc:GetFlagEffect(3336)==0 then
			local e1=Effect.CreateEffect(tc)
			e1:SetType(EFFECT_TYPE_FIELD)
			e1:SetDescription(aux.Stringid(3336,0))
			e1:SetCode(EFFECT_SPSUMMON_PROC)
			e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
			e1:SetRange(LOCATION_EXTRA)
			e1:SetValue(SUMMON_TYPE_XYZ)
			e1:SetCondition(c3336.xyzcon)
			e1:SetOperation(c3336.xyzop)
			e1:SetLabelObject(tck)
			e1:SetReset(RESET_EVENT+EVENT_ADJUST,1)
			tc:RegisterEffect(e1)
			tc:RegisterFlagEffect(3336,RESET_EVENT+EVENT_ADJUST,0,1) 	
		end
		tc=g:GetNext()
	end
end
function c3336.mfilter(c,rk,xyz)
	return c:IsFaceup() and c:IsCanBeXyzMaterial(xyz) and c:IsXyzLevel(xyz,rk)
end
function c3336.subfilter(c,rk,xyz,tck)
	return (c:IsFaceup() and c.xyzsub and c.xyzsub==rk and not c:IsStatus(STATUS_DISABLED))
end
function c3336.gafilter(c,rk,xyz)
	return c:IsFaceup() and c:IsCanBeXyzMaterial(xyz) and c:IsXyzLevel(xyz,rk) and c:IsSetCard(0x54) and c:IsType(TYPE_MONSTER)
end
function c3336.xyzcon(e,c,og)
	if c==nil then return true end
	local tp=c:GetControler()
	local rk=c:GetRank()
	local ct=c.xyz_count
	local mg=Duel.GetMatchingGroup(c3336.mfilter,tp,LOCATION_MZONE,0,nil,rk,c)
	local tck=e:GetLabelObject()
	local mg2=Duel.GetMatchingGroup(c3336.subfilter,tp,LOCATION_ONFIELD,0,nil,rk,c,tck)
	mg:Merge(mg2)
	if Duel.IsPlayerAffectedByEffect(tp,4161) then
	local dob=mg:Filter(c3336.gafilter,nil,rk,c)
	local dobc=dob:GetFirst()
	while dobc do
		ct=ct-1
		dobc=dob:GetNext()
	end
	end
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>-1 and mg:GetCount()>=ct
end
function c3336.xyzop(e,tp,eg,ep,ev,re,r,rp,c,og)
	local c=e:GetHandler()
	local rk=c:GetRank()
	local ct=c.xyz_count
	local mg=Duel.GetMatchingGroup(c3336.mfilter,tp,LOCATION_MZONE,0,nil,rk,c)
	local tck=e:GetLabelObject()
	local mg2=Duel.GetMatchingGroup(c3336.subfilter,tp,LOCATION_ONFIELD,0,nil,rk,c,tck)
	local gg=Duel.GetMatchingGroup(c3336.gafilter,tp,LOCATION_MZONE,0,nil,rk,c)
	mg:Merge(mg2)
	local matc=mg:GetCount()+gg:GetCount()
	local g1=Group.CreateGroup()
	g1:KeepAlive()
	while ct>0 do
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
		local gc=mg:Select(tp,1,1,nil):GetFirst()
		if gc and Duel.IsPlayerAffectedByEffect(tp,4161) and gc:IsSetCard(0x54) and ct>0 and (matc<=ct or Duel.SelectYesNo(tp,aux.Stringid(4161,0))) then
			ct=ct-1
			matc=matc-1
		end
		mg:RemoveCard(gc)
		g1:AddCard(gc)
		matc=matc-1
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
function c3336.effectcon(e)
	local c=e:GetHandler()
	return c:GetFlagEffect(3336)==0 or c:IsHasEffect(EFFECT_CANNOT_DISABLE)
end
