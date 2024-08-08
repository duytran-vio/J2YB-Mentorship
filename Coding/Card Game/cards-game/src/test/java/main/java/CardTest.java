package main.java;

import static org.junit.jupiter.api.Assertions.assertEquals;

import org.junit.jupiter.api.Test;

import main.java.utils.SuitType;

public class CardTest {
    @Test
    void testCreateCard() {
        Card card = Card.create("2", SuitType.HEARTS);
        assertEquals("2", card.getRank());
        assertEquals(SuitType.HEARTS, card.getSuit());
    }

    @Test
    void testShowCard() {
        Card card = Card.create("2", SuitType.HEARTS);
        String expectedCardValue = "2" + SuitType.HEARTS.getSymbol();

        String cardValue = card.show();
        assertEquals(expectedCardValue, cardValue);
    }

    @Test
    void testCompareTo_WhenFirstCardIsHigher() {
        Card card1 = Card.create("3", SuitType.HEARTS);
        Card card2 = Card.create("2", SuitType.HEARTS);

        int result = card1.compareTo(card2);
        assertEquals(1, result);
    }
}
