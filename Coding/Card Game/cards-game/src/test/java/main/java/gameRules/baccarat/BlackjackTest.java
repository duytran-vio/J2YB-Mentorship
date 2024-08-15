package main.java.gameRules.baccarat;

import static org.junit.jupiter.api.Assertions.assertEquals;

import org.junit.jupiter.api.Test;

public class BlackjackTest {

    @Test
    public void testCreateBlackjackGame() {
        Blackjack blackjack = new Blackjack();
        assertEquals(blackjack.getConfigGameRule().getMaxPlayers(), 7);
        assertEquals(blackjack.getConfigGameRule().getMinPlayers(), 2);
        assertEquals(blackjack.getConfigGameRule().getCardsFirstDealEachPlayer(), 2);
        assertEquals(blackjack.getConfigGameRule().getMaxCardsEachPlayer(), 5);
    }

    @Test
    public void testCreateBlackjackGame_deckFull() {
        Blackjack blackjack = new Blackjack();
        assertEquals(blackjack.getDeck().getCards().size(), 52);
    }
}
