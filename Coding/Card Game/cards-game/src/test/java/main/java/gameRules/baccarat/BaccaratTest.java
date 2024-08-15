package main.java.gameRules.baccarat;

import static org.assertj.core.api.Assertions.assertThat;
import static org.junit.jupiter.api.Assertions.assertEquals;

import java.util.List;

import org.junit.jupiter.api.Test;

import main.java.Card;
import main.java.Deck;
import main.java.gameRules.ConfigGameRule;
import main.java.utils.RankType;
import main.java.utils.SuitType;

public class BaccaratTest {

    @Test
    public void testCreateBaccaratGame() {
        Baccarat baccarat = new Baccarat();
        ConfigGameRule configGameRule = baccarat.getConfigGameRule();
        assertEquals(configGameRule.getMaxPlayers(), 26);
        assertEquals(configGameRule.getMinPlayers(), 2);
        assertEquals(configGameRule.getCardsFirstDealEachPlayer(), 3);
        assertEquals(configGameRule.getMaxCardsEachPlayer(), 3);
    }

    @Test
    public void testCreateBaccaratGame_deckExcludesTenJQKCards() {
        List<Card> excludeCards = List.of(
            new Card(RankType.TEN, SuitType.CLUBS),
            new Card(RankType.JACK, SuitType.CLUBS),
            new Card(RankType.QUEEN, SuitType.CLUBS),
            new Card(RankType.KING, SuitType.CLUBS)
        );

        Baccarat baccarat = new Baccarat();
        Deck deck = baccarat.getDeck();
        assertEquals(deck.getCards().size(), 36);
        assertThat(deck.getCards()).doesNotContainAnyElementsOf(excludeCards);
    }
}
