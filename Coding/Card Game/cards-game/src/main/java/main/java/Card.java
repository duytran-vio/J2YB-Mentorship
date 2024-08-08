package main.java;

import lombok.Getter;
import lombok.Setter;
import main.java.utils.SuitType;

@Setter
@Getter
public class Card {
    private String rank;
    private SuitType suit;

    public Card(String rank, SuitType suit) {
        this.rank = rank;
        this.suit = suit;
    }

    public static Card create(String rank, SuitType suit) {
        return new Card(rank, suit);
    }

    public String show() {
        return rank + suit.getSymbol();
    }

    public int compareTo(Card card2) {
        // TODO Auto-generated method stub
        throw new UnsupportedOperationException("Unimplemented method 'compareTo'");
    }
}
