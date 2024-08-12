package main.java;

import lombok.Getter;
import lombok.Setter;
import main.java.utils.RankType;
import main.java.utils.SuitType;

@Setter
@Getter
public class Card {
    private RankType rank;
    private SuitType suit;

    public Card(RankType rank, SuitType suit) {
        this.rank = rank;
        this.suit = suit;
    }

    public static Card create(RankType rank, SuitType suit) {
        return new Card(rank, suit);
    }

    public String show() {
        return rank.getRank() + suit.getSymbol();
    }
}
