# higher_lower_game
TODO:
	
	Hand -> Holds many Cards
		Position given to Card based on index in hand
	Deck -> Holds all undrawn cards
	
	GameManager -> Interactions between states
		Draw(x) -> Draw from a Deck to a Hand


Game:
	Game draws a card from the deck and places it upside down in the Play Area
	Player has a hand of 3 cards, he can play a card from his hand to the Play Area
	When a card is played, the initial card is revealed.
	If the card is higher, the player wins score
	If it's lower, the player loses score

That's it for our first 'game'
