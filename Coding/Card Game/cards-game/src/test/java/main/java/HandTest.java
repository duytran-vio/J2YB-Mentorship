package main.java;

import static org.junit.jupiter.api.Assertions.assertEquals;

import java.util.ArrayList;
import java.util.List;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;

import main.java.utils.RankType;
import main.java.utils.SuitType;

public class HandTest {

    private Deck deck;

    @BeforeEach
    public void setUp() {
        deck = new Deck();
    }

    @Test
    void testAddAll_WhenListOfCard_ThenReturnCorrectSize() {
        List<Integer> indexes = new ArrayList<>(){
            {
                add(2);
                add(3);
                add(4);
                add(5);
            }
        };
        Hand hand = new Hand();
        hand.addAll(deck.drawCards(indexes));
        assertEquals(indexes.size(), hand.getSize());
    }

    @Test
    void testShow_WhenHandHasCards_ThenReturnCorrectString() {
        List<Card> cards = new ArrayList<>(){
            {
                add(new Card(RankType.FOUR, SuitType.HEARTS));
                add(new Card(RankType.FIVE, SuitType.HEARTS));
                add(new Card(RankType.SIX, SuitType.HEARTS));
                add(new Card(RankType.SEVEN, SuitType.HEARTS));
            }
        };
        Hand hand = new Hand(cards);
        String expected = "Cards in hand: \n" +
                            "0. 4♥\n" +
                            "1. 5♥\n" +
                            "2. 6♥\n" +
                            "3. 7♥\n";
        assertEquals(expected, hand.show());
    }
}
