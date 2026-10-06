extends Resource

class_name CardEffectResource

enum CardEffect {
	Attack,
	Block,
	Draw,
}

@export var effect_type: CardEffect
@export var value: int
