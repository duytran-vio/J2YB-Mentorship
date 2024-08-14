package main.java;

import java.util.ArrayList;
import java.util.List;

public class Hand extends Deck {
    public Hand() {
        this.cards = new ArrayList<Card>();
    }

    public Hand(List<Card> cards) {
        this.cards = cards;
    }

    public void addAll(List<Card> cards) {
        this.cards.addAll(cards);
    }

    public String show(){
        String handStr = "Cards in hand: \n";
        for (int i = 0; i < cards.size(); i++) {
            handStr += i + ". " + cards.get(i).show() + "\n";
        }
        return handStr;
    }
}
