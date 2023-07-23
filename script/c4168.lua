--CX 冀望皇バリアン
function c4168.initial_effect(c)
	--xyz summon
	c:EnableReviveLimit()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetCondition(c4168.xyzcon)
	e1:SetOperation(c4168.xyzop)
	e1:SetValue(SUMMON_TYPE_XYZ)
	c:RegisterEffect(e1)
	--atk
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_SET_ATTACK)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetValue(c4168.atkval)
	c:RegisterEffect(e2)
	--copy
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(4168,1))
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	c:RegisterEffect(e3)
end
function c4168.ovfilter1(c,xc)
	local code=c:GetCode()
	local class=_G["c"..code]
	if class==nil then return false end
	local no=class.xyz_number
	return c:IsFaceup() and ((no and no>=101 and no<=107 and c:IsSetCard(0x1048) and c:IsType(TYPE_XYZ)) or c:IsXyzLevel(xc,7))
end
function c4168.ovfilter2(c,xc)
	local code=c:GetCode()
	local class=_G["c"..code]
	if class==nil then return false end
	local no=class.xyz_number
	return c:IsFaceup() and no and no>=101 and no<=107 and c:IsSetCard(0x1048) and c:IsType(TYPE_XYZ)
end
function c4168.xyzcon(e,c,og,min,max)
	if c==nil then return true end
	local tp=c:GetControler()
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local minc=3
	local maxc=64
	if min then
		minc=math.max(minc,min)
		maxc=max
	end
	local ct=math.max(minc-1,-ft)
	local mg=nil
	if og then
		mg=og:Filter(c4168.ovfilter1,nil,c)
	else
		mg=Duel.GetMatchingGroup(c4168.ovfilter1,tp,LOCATION_MZONE,0,nil,c)
		mg2=Duel.GetMatchingGroup(c4168.ovfilter2,tp,0,LOCATION_MZONE,nil,c)
		mg:Merge(mg2)
	end
	return maxc>=3 and mg:GetCount()>=3
end
function c4168.xyzop(e,tp,eg,ep,ev,re,r,rp,c,og,min,max)
	local g=nil
	if og and not min then
		g=og
	else
		local mg=nil
		if og then
			mg=og:Filter(c4168.ovfilter1,nil,c)
		else
			mg=Duel.GetMatchingGroup(c4168.ovfilter1,tp,LOCATION_MZONE,0,nil,c)
			mg2=Duel.GetMatchingGroup(c4168.ovfilter2,tp,0,LOCATION_MZONE,nil,c)
			mg:Merge(mg2)
		end
		local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
		local minc=3
		local maxc=64
		if min then
			minc=math.max(minc,min)
			maxc=max
		end
		local ct=math.max(minc-1,-ft)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
		g=mg:FilterSelect(tp,c4168.ovfilter1,3,maxc,nil,mg,ct)
	end
	local sg=Group.CreateGroup()
	local tc=g:GetFirst()
	while tc do
		sg:Merge(tc:GetOverlayGroup())
		tc=g:GetNext()
	end
	Duel.SendtoGrave(sg,REASON_RULE)
	c:SetMaterial(g)
	Duel.Overlay(c,g)
end
function c4168.atkval(e,c)
	return c:GetOverlayCount()*1000
end
