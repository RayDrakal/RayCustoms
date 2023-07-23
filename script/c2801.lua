--アストログラフ・マジシャン
function c2801.initial_effect(c)
	--Special Summon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetDescription(aux.Stringid(2801,0))
	e1:SetCode(EVENT_DESTROYED)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c2801.spcon)
	e1:SetTarget(c2801.sptg)
	e1:SetOperation(c2801.spop)
	c:RegisterEffect(e1)
	--Arrange
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetCondition(c2801.spcon2)
	e2:SetTarget(c2801.sptg2)
	e2:SetOperation(c2801.spop2)
	c:RegisterEffect(e2)
	--Zarc
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(2801,1))
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetCost(c2801.zcost)
	e3:SetTarget(c2801.ztg)
	e3:SetOperation(c2801.zop)
	c:RegisterEffect(e3)
	--check
	if not c2801.global_flag then
		c2801.global_flag=true
		c2801.desgroup=Group.CreateGroup()
		c2801.desgroup:KeepAlive()
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_DESTROYED)
		ge1:SetOperation(c2801.checkop)
		Duel.RegisterEffect(ge1,0)
		local ge2=Effect.CreateEffect(c)
		ge2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge2:SetCode(EVENT_PHASE_START+PHASE_DRAW)
		ge2:SetOperation(c2801.resetop)
		Duel.RegisterEffect(ge2,0)
	end
end
function c2801.spcfilter(c,tp)
	return c:IsReason(REASON_BATTLE+REASON_EFFECT) and c:GetPreviousControler()==tp
	and not c:IsType(TYPE_TOKEN)
end
function c2801.spcon(e,tp,eg,ep,ev,re,r,rp)
	return eg and eg:IsExists(c2801.spcfilter,1,nil,tp)
end
function c2801.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
	if chkc then return chkc==eg end
	Duel.SetTargetCard(eg)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c2801.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local sg=Group.CreateGroup()
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	if not c:IsRelateToEffect(e) then return end
	if g:GetCount()>0 then
		local tc=g:GetFirst()
		while tc do
			tc:RegisterFlagEffect(2801,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1)
			tc=g:GetNext()
		end
	end
	if Duel.SpecialSummon(c,1,tp,tp,false,false,POS_FACEUP)==0 and Duel.GetLocationCount(tp,LOCATION_MZONE)<=0
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false) then
		Duel.SendtoGrave(c,REASON_RULE)
		return
	end
end
function c2801.spcon2(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_SPECIAL+1
end
function c2801.mfilter(c,e)
	return c:GetFlagEffect(2801)~=0 and c:GetFlagEffect(280101)~=0 and c:IsType(TYPE_MONSTER)
end
function c2801.sfilter(c,e)
	return c:GetFlagEffect(2801)~=0 and c:GetFlagEffect(280102)~=0 and c:IsType(TYPE_SPELL+TYPE_TRAP) and not c:IsType(TYPE_PENDULUM)
end
function c2801.pfilter(c,e)
	return c:GetFlagEffect(2801)~=0 and c:GetFlagEffect(280103)~=0 and c:IsType(TYPE_PENDULUM)
end
function c2801.sptg2(e,tp,eg,ep,ev,re,r,rp,chk)
	local mg=Duel.GetMatchingGroup(c2801.mfilter,tp,LOCATION_ONFIELD+LOCATION_GRAVE+LOCATION_REMOVED,LOCATION_ONFIELD+LOCATION_GRAVE+LOCATION_REMOVED,nil)
	local sg=Duel.GetMatchingGroup(c2801.sfilter,tp,LOCATION_ONFIELD+LOCATION_GRAVE+LOCATION_REMOVED,LOCATION_ONFIELD+LOCATION_GRAVE+LOCATION_REMOVED,nil)
	local pg=Duel.GetMatchingGroup(c2801.pfilter,tp,LOCATION_ONFIELD+LOCATION_GRAVE+LOCATION_REMOVED,LOCATION_ONFIELD+LOCATION_GRAVE+LOCATION_REMOVED,nil)
	local ml=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local sl=Duel.GetLocationCount(tp,LOCATION_SZONE)
	local pl=0
	if Duel.GetFieldCard(tp,LOCATION_PZONE,0) then pl=pl+1 end
	if Duel.GetFieldCard(tp,LOCATION_PZONE,1) then pl=pl+1 end
	if chk==0 then return (ml>=mg:GetCount()) and (sl>=sg:GetCount()) and (pl>=pg:GetCount()) end
end
function c2801.spop2(e,tp,eg,ep,ev,re,r,rp)
	local mg=Duel.GetMatchingGroup(c2801.mfilter,tp,LOCATION_ONFIELD+LOCATION_GRAVE+LOCATION_REMOVED+LOCATION_EXTRA,LOCATION_ONFIELD+LOCATION_GRAVE+LOCATION_REMOVED+LOCATION_EXTRA,nil)
	local sg=Duel.GetMatchingGroup(c2801.sfilter,tp,LOCATION_ONFIELD+LOCATION_GRAVE+LOCATION_REMOVED,LOCATION_ONFIELD+LOCATION_GRAVE+LOCATION_REMOVED,nil)
	local pg=Duel.GetMatchingGroup(c2801.pfilter,tp,LOCATION_ONFIELD+LOCATION_GRAVE+LOCATION_REMOVED+LOCATION_EXTRA,LOCATION_ONFIELD+LOCATION_GRAVE+LOCATION_REMOVED+LOCATION_EXTRA,nil)
	local ml=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local sl=Duel.GetLocationCount(tp,LOCATION_SZONE)
	local pl=2
	if Duel.GetFieldCard(tp,LOCATION_PZONE,0) then pl=pl-1 end
	if Duel.GetFieldCard(tp,LOCATION_PZONE,1) then pl=pl-1 end
	if not((ml>=mg:GetCount()) or (sl>=sg:GetCount()) or (pl>=pg:GetCount()) )then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	--monster
	local mc=mg:GetFirst()
	while mc do
		if mc then
			Duel.MoveToField(mc,tp,tp,LOCATION_MZONE,POS_FACEUP,true)
		end
		mc=mg:GetNext()
	end
	--spell&trap
	local sc=sg:GetFirst()
	while sc do
		if sc then
			Duel.MoveToField(sc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
		end
		sc=sg:GetNext()
	end
	--pendulum
	local pc=pg:GetFirst()
	while pc do
		if pc then
			Duel.MoveToField(pc,tp,tp,LOCATION_PZONE,POS_FACEUP,true)
		end
		pc=pg:GetNext()
	end
end
function c2801.checkop(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	while tc do
		if tc:IsReason(REASON_DESTROY) and tc:IsPreviousLocation(LOCATION_MZONE) and not tc:IsType(TYPE_TOKEN) then
			tc:RegisterFlagEffect(280101,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1)
		elseif tc:IsReason(REASON_DESTROY) and tc:IsPreviousLocation(LOCATION_SZONE) and not tc:IsPreviousLocation(LOCATION_PZONE) then
			tc:RegisterFlagEffect(280102,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1)
		elseif tc:IsReason(REASON_DESTROY) and tc:IsPreviousLocation(LOCATION_PZONE) then
			tc:RegisterFlagEffect(280103,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
		end
		tc=eg:GetNext()
	end
end
function c2801.zcfilter(c,sc)
	return c:IsCode(sc) and c:IsAbleToRemove()
end
function c2801.zfilter(c,e,tp,sg)
	return c:IsCode(13331639) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_SPECIAL,tp,true,true)
	and (not sg or Duel.GetLocationCountFromEx(tp,tp,sg,c)>0)
end
function c2801.zcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsReleasable() end
	Duel.Release(e:GetHandler(),REASON_COST)
end
function c2801.ztg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c2801.zfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp,nil)
	and Duel.IsExistingMatchingCard(c2801.zcfilter,tp,LOCATION_ONFIELD+LOCATION_GRAVE+LOCATION_DECK+LOCATION_EXTRA,0,1,nil,16178681) 
	and Duel.IsExistingMatchingCard(c2801.zcfilter,tp,LOCATION_ONFIELD+LOCATION_GRAVE+LOCATION_DECK+LOCATION_EXTRA,0,1,nil,16195942)
	and Duel.IsExistingMatchingCard(c2801.zcfilter,tp,LOCATION_ONFIELD+LOCATION_GRAVE+LOCATION_DECK+LOCATION_EXTRA,0,1,nil,41209827)
	and Duel.IsExistingMatchingCard(c2801.zcfilter,tp,LOCATION_ONFIELD+LOCATION_GRAVE+LOCATION_DECK+LOCATION_EXTRA,0,1,nil,82044279)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c2801.zop(e,tp,eg,ep,ev,re,r,rp)
	if not ( Duel.IsExistingMatchingCard(c2801.zcfilter,tp,LOCATION_ONFIELD+LOCATION_GRAVE+LOCATION_DECK+LOCATION_EXTRA,0,1,nil,16178681) 
		and Duel.IsExistingMatchingCard(c2801.zcfilter,tp,LOCATION_ONFIELD+LOCATION_GRAVE+LOCATION_DECK+LOCATION_EXTRA,0,1,nil,16195942)
		and Duel.IsExistingMatchingCard(c2801.zcfilter,tp,LOCATION_ONFIELD+LOCATION_GRAVE+LOCATION_DECK+LOCATION_EXTRA,0,1,nil,41209827)
		and Duel.IsExistingMatchingCard(c2801.zcfilter,tp,LOCATION_ONFIELD+LOCATION_GRAVE+LOCATION_DECK+LOCATION_EXTRA,0,1,nil,82044279))
	then
		return
	end
	local g=Group.FromCards(c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g1=Duel.SelectMatchingCard(tp,c2801.zcfilter,tp,LOCATION_ONFIELD+LOCATION_GRAVE+LOCATION_DECK+LOCATION_EXTRA,0,1,1,nil,16178681)
	g:Merge(g1)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g1=Duel.SelectMatchingCard(tp,c2801.zcfilter,tp,LOCATION_ONFIELD+LOCATION_GRAVE+LOCATION_DECK+LOCATION_EXTRA,0,1,1,nil,16195942)
	g:Merge(g1)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g1=Duel.SelectMatchingCard(tp,c2801.zcfilter,tp,LOCATION_ONFIELD+LOCATION_GRAVE+LOCATION_DECK+LOCATION_EXTRA,0,1,1,nil,41209827)
	g:Merge(g1)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g1=Duel.SelectMatchingCard(tp,c2801.zcfilter,tp,LOCATION_ONFIELD+LOCATION_GRAVE+LOCATION_DECK+LOCATION_EXTRA,0,1,1,nil,82044279)
	g:Merge(g1)
	if Duel.Remove(g,POS_FACEUP,REASON_EFFECT)==4 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,c2801.zfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
		if g:GetCount()>0 then
			Duel.SpecialSummon(g,SUMMON_TYPE_FUSION,tp,tp,true,true,POS_FACEUP)
		end
	end
end
