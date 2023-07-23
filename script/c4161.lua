--ガガガミラージュ
function c4161.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(4161)
	e2:SetRange(LOCATION_SZONE)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetTargetRange(1,0)
	c:RegisterEffect(e2)
	--xyz summon
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_ADJUST)
	e3:SetRange(LOCATION_SZONE)	
	e3:SetOperation(c4161.op)
	c:RegisterEffect(e3)
end
function c4161.filterx(c,mg)
	return c:IsType(TYPE_XYZ) and c.xyz_count and c.xyz_count>0
end
function c4161.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(c4161.filterx,c:GetControler(),LOCATION_EXTRA,LOCATION_EXTRA,nil)
	local tc=g:GetFirst()
	while tc do
		local tck=Duel.CreateToken(tp,4161)
		if tc:GetFlagEffect(4161)==0 then
			local e1=Effect.CreateEffect(tc)
			e1:SetType(EFFECT_TYPE_FIELD)
			e1:SetDescription(aux.Stringid(4161,0))
			e1:SetCode(EFFECT_SPSUMMON_PROC)
			e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
			e1:SetRange(LOCATION_EXTRA)
			e1:SetValue(SUMMON_TYPE_XYZ)
			e1:SetCondition(c4161.xyzcon)
			e1:SetOperation(c4161.xyzop)
			e1:SetLabelObject(tck)
			e1:SetReset(RESET_EVENT+EVENT_ADJUST,1)
			tc:RegisterEffect(e1)
			tc:RegisterFlagEffect(4161,RESET_EVENT+EVENT_ADJUST,0,1) 	
		end
		tc=g:GetNext()
	end
end
function c4161.gafilter(c,rk,xyz)
	return c:IsFaceup() and c:IsCanBeXyzMaterial(xyz) and c:IsXyzLevel(xyz,rk) and c:IsSetCard(0x54) and c:IsType(TYPE_MONSTER)
end
function c4161.notgafilter(c,rk,xyz)
	return c:IsFaceup() and c:IsCanBeXyzMaterial(xyz) and c:IsXyzLevel(xyz,rk) and not c:IsSetCard(0x54) and c:IsType(TYPE_MONSTER)
end
function c4161.xyzcon(e,c,og)
	if c==nil then return true end
	local tp=c:GetControler()
	local rk=c:GetRank()
	local ct=c.xyz_count
	local mg=Duel.GetMatchingGroup(c4161.gafilter,tp,LOCATION_MZONE,0,nil,rk,c)
	local mg2=Duel.GetMatchingGroup(c4161.notgafilter,tp,LOCATION_MZONE,0,nil,rk,c)
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>-1 and mg:GetCount()*2+mg2:GetCount()>=ct
	and Duel.IsPlayerAffectedByEffect(tp,4161)
	and c:GetFlagEffect(3336)==0
end
function c4161.xyzop(e,tp,eg,ep,ev,re,r,rp,c,og)
	local c=e:GetHandler()
	local rk=c:GetRank()
	local ct=c.xyz_count
	local mg=Duel.GetMatchingGroup(c4161.gafilter,tp,LOCATION_MZONE,0,nil,rk,c)
	local mg2=Duel.GetMatchingGroup(c4161.notgafilter,tp,LOCATION_MZONE,0,nil,rk,c)
	mg:Merge(mg2)
	local g1=Group.CreateGroup()
	g1:KeepAlive()
	while ct>0 do
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
		local gc=mg:Select(tp,1,1,nil):GetFirst()
		g1:AddCard(gc)
		mg:RemoveCard(gc)
		if gc:IsSetCard(0x54) and (mg:GetCount()<=1 or Duel.SelectYesNo(tp,aux.Stringid(4161,0)))  then
		ct=ct-2
		else
		ct=ct-1
		end
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
