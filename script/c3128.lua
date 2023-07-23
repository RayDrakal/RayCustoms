--フルアーマー・グラビテーション
function c3128.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c3128.target)
	e1:SetOperation(c3128.operation)
	c:RegisterEffect(e1)
end
function c3128.filter(c,e,tp)
	return c:IsLevelBelow(4) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
		and c:IsCode(3115,3116,3117,3118,3119,3120,3121,3122,3123,3124,3125,3126)
end
function c3128.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsPlayerCanSpecialSummon(tp)
		and Duel.IsExistingMatchingCard(c3128.filter,tp,LOCATION_DECK,0,1,nil,e,tp) and Duel.IsPlayerCanDraw(tp,10) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(10)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,10)
end
function c3128.operation(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	local i
	local sg=Group.CreateGroup()
	local rg=Group.CreateGroup()
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	for i=1,d do
		Duel.Draw(p,1,REASON_EFFECT)
		local g=Duel.GetOperatedGroup()
		if g:Filter(c3128.filter,nil,e,tp):GetCount()>0 and ft>0 then
			sg:AddCard(g:GetFirst())
			ft=ft-1
		else
			rg:AddCard(g:GetFirst())
		end
	end
	Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
	Duel.Remove(rg,POS_FACEUP,REASON_EFFECT)
end
