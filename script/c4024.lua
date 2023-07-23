--Ｎｏ３　ゲート・オブ・ヌメロン―トゥリーニ
function c4024.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,nil,1,3)
	c:EnableReviveLimit()
	--nuemron
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(4024,0))
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetCondition(c4024.con)
	e1:SetCode(EVENT_DAMAGE_STEP_END)
	e1:SetTarget(c4024.drtg)
	e1:SetOperation(c4024.drop)
	c:RegisterEffect(e1)
	--No
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e2:SetValue(c4024.indval)
	c:RegisterEffect(e2)
end
function c4024.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c4024.filter,tp,LOCATION_MZONE,0,1,nil) end
	local g=Duel.GetMatchingGroup(c4024.filter,tp,LOCATION_MZONE,0,nil)
	Duel.SetTargetCard(g)
end
function c4024.drop(e,tp,eg,ep,ev,re,r,rp)
	local sg=Duel.GetMatchingGroup(c4024.filter,tp,LOCATION_MZONE,0,nil,e)
	local c=e:GetHandler()
	local fid=c:GetFieldID()
	local tc=sg:GetFirst()
	while tc do
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_ATTACK_FINAL)
		e1:SetValue(tc:GetAttack()*2)
		tc:RegisterEffect(e1)
		tc=sg:GetNext()
	end
end
function c4024.filter(c,e,tp)
	return c:IsSetCard(0x14a)
end
function c4024.indval(e,c)
	return not c:IsSetCard(0x48)
end
function c4024.con(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsEnvironment(41418852)
end
function c4024.cfilter(c)
	return c:IsFaceup() and c:IsCode(41418852)
end
