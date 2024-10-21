from flask import Flask, request, jsonify
import random
from flask_cors import CORS
from paquet import json_to_cards
from Play import select_best_card_with_NN
from paquet import transform_color_name
from paquet import parsing_of_card_to_return
from Play import select_best_card_with_NN_level_easy
from Play_mcts import json_to_cards_mcts
from Play_mcts import select_best_card_with_MCTS
from Hearts import Card
app = Flask(__name__)
CORS(app)

listOfPossibleCards = [...]

listOfIa = {}
listOfDifficulty={}

@app.route('/initialisation', methods=['POST'])
def initialisation():
    global listOfIa

    data = request.json

    if 'ia_players' in data:
        ia_players = data['ia_players']

        for joueur in ia_players:
            id_joueur = joueur.get('id')
            type_joueur = joueur.get('type')
            difficulte = joueur.get('difficulte')

            listOfIa[id_joueur] = type_joueur
            listOfDifficulty[id_joueur]=difficulte
        print(listOfIa)
        print(listOfDifficulty)
        return 'Initialisation réussie'

    else:
        return 'Données JSON invalides', 400



@app.route('/play_move', methods=['POST'])
def play_move():
    global listOfPossibleCards

    # Récupère la taille envoyée par le client
    data = request.json
    taille = data.get('taille')
    scores = data.get('scores')
    all_cards = data.get('all_cards')
    player_number = data.get('number_of_player')
    trick_number = data.get('trick_number')
    cards_in_hand = data.get('cards_in_hand')
    card_played_in_trick=data.get('card_played_in_trick')
    trump_color = data.get('trump_color')
    order_of_play = data.get('order_of_play')
    playable_cards = data.get('playable_cards')
    flag = data.get('flag')
    
    difficulte = listOfDifficulty[player_number]
    type_ia = listOfIa[player_number]
    if(type_ia=="MCTS"):
        parsed_cards_in_hand = json_to_cards_mcts(cards_in_hand)
        parsed_card_played_in_trick = json_to_cards_mcts(card_played_in_trick)
        parsed_all_cards = json_to_cards_mcts(all_cards)
        print(all_cards)
        if(difficulte=="Easy"):
            card_to_be_played= select_best_card_with_MCTS(parsed_cards_in_hand,order_of_play,parsed_all_cards,parsed_card_played_in_trick,scores,2)
            suit,rank = Card.parsing_of_card_to_return_mcts(card_to_be_played)
        else:
            card_to_be_played= select_best_card_with_MCTS(parsed_cards_in_hand,order_of_play,parsed_all_cards,parsed_card_played_in_trick,scores,10)
            suit,rank = Card.parsing_of_card_to_return_mcts(card_to_be_played)
    else:
        parsed_cards_in_hand = json_to_cards(cards_in_hand)
        parsed_card_played_in_trick = json_to_cards(card_played_in_trick)
        parsed_playable_cards = json_to_cards(playable_cards)
        parsed_color_name = transform_color_name(trump_color)
        if(difficulte=="Easy"):
            card_to_be_played = select_best_card_with_NN_level_easy(trick_number,parsed_cards_in_hand,parsed_playable_cards,parsed_card_played_in_trick,parsed_color_name,order_of_play,flag)
            suit,rank = parsing_of_card_to_return(card_to_be_played)
        else :
            card_to_be_played = select_best_card_with_NN(trick_number,parsed_cards_in_hand,parsed_playable_cards,parsed_card_played_in_trick,parsed_color_name,order_of_play,flag)
            suit,rank = parsing_of_card_to_return(card_to_be_played)
        print(card_to_be_played)
    
    return jsonify({'suit': suit,'rank': rank})


if __name__ == '__main__':
    app.run(host='127.0.0.1', port=5000)
