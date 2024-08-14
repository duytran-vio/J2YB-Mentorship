package main.java;

import static org.junit.jupiter.api.Assertions.assertEquals;

import org.junit.jupiter.api.Test;

import main.java.utils.RankType;
import main.java.utils.SuitType;

public class CardTest {
    @Test
    void testCreateCard_ThenReturnCorrectRankAndSuit() {
        Card card = Card.create(RankType.TWO, SuitType.HEARTS);
        assertEquals(RankType.TWO, card.getRank());
        assertEquals(SuitType.HEARTS, card.getSuit());
    }

    @Test
    void testShowCard_ThenReturnStringHasCorrectRankAndSuit() {
        Card card = Card.create(RankType.TWO, SuitType.HEARTS);
        String expectedCardValue = "2" + SuitType.HEARTS.getSymbol();

        String cardValue = card.show();
        assertEquals(expectedCardValue, cardValue);
    }

    @Test
    void testEquals_WhenTwoCardsHaveSameRankAndSuit_ThenReturnTrue() {
        Card card1 = Card.create(RankType.TWO, SuitType.HEARTS);
        Card card2 = Card.create(RankType.TWO, SuitType.HEARTS);

        assertEquals(true, card1.equals(card2));
    }
}
