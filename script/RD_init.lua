--

-- races

--


-- archetype
SET_STARVADER            = 0x5a1

-- counter

-- card Scharhrot
CARD_YOUTH_BERK         = 110810001
CARD_SCHARHROT          = 110815000
CARD_LINKEDVADE         = 110852000

-- specific functions
function Auxiliary.StarVadeLimit(e,se,sp,st)
	return se:GetHandler():IsCode(CARD_LINKEDVADE)
end
function Card.AddMustBeSpecialSummonedByLinkedVade(c)
	local metatable=Duel.GetMetatable(c:GetOriginalCode())
	metatable.starvader_invite=true
	--Must be Special Summoned with "Dark Fusion"
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	e0:SetValue(aux.StarVadeLimit)
	c:RegisterEffect(e0)
	--"Clock Lizard" check
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(CARD_CLOCK_LIZARD)
	e1:SetValue(1)
	c:RegisterEffect(e1)
	return e0
end