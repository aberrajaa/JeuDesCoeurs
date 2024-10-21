from Hearts import *
from Hearts import Card



def json_to_cards_mcts(json_data):
    cards = []
    for item in json_data:
        suit = item['suit']
        rank = item['rank']
        couleur = Card.suit_to_couleur[suit]
        rang = Card.rank_to_rang[rank]
        cards.append((couleur, rang))
    list_of_cards = []
    for couleur, rang in cards:
        card = Card(couleur, rang)
        list_of_cards.append(card)
    return list_of_cards

def select_best_card_with_MCTS(player_hand, player_index, all_played_cards, current_trick, scores):
    mcts = MCTSPlayer('MCTS')
    mcts.hand = player_hand
    mcts.sort_hand()
    mcts.points = scores[player_index]
    deck = Deck()
    for i in range(32):
        deck.draw_card()
    for card in all_played_cards:
        deck.add_card(card)
    state = State(deck, current_trick, scores, player_index)
    card_to_play = mcts.do_action(state)
    return card_to_play