package main.java;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertTrue;
import static org.assertj.core.api.Assertions.*;

import java.util.ArrayList;
import java.util.List;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;

import main.java.utils.RankType;
import main.java.utils.SuitType;

public class PlayerTest {

    private Player player;
    private Deck deck;

    @BeforeEach
    public void setUp() {
        player = new Player("John");
        deck = new Deck();

        List<Card> mockCards = new ArrayList<>(){
            {
                add(new Card(RankType.TWO, SuitType.HEARTS));
                add(new Card(RankType.THREE, SuitType.HEARTS));
                add(new Card(RankType.FOUR, SuitType.HEARTS));
                add(new Card(RankType.FIVE, SuitType.HEARTS));
                add(new Card(RankType.SIX, SuitType.HEARTS));
                add(new Card(RankType.SEVEN, SuitType.HEARTS));
                add(new Card(RankType.EIGHT, SuitType.HEARTS));
                add(new Card(RankType.NINE, SuitType.HEARTS));
                add(new Card(RankType.TEN, SuitType.HEARTS));
            }
        };
        player.receiveCards(mockCards);
    }

    @Test
    public void testCreateNewPlayer() {
        assertEquals("John", player.getName());
    }

    @Test
    public void testReceiveCards_WhenInputListOfCards_ThenReturnCorrectHandSize() {
        List<Integer> indexes = new ArrayList<>(){
            {
                add(2);
                add(3);
                add(4);
                add(5);
            }
        };
        List<Card> cards = deck.drawCards(indexes);
        int oldHandSize = player.getHand().getSize();
        player.receiveCards(cards);
        assertEquals(indexes.size() + oldHandSize, player.getHand().getSize());
        assertThat(player.getHand().getCards()).containsAll(cards);
    }

    @Test
    public void testDealCards_WhenInputIndexes_ThenReturnListOfCards() {
        List<Integer> indexes = new ArrayList<>(){
            {
                add(2);
                add(3);
                add(4);
                add(5);
            }
        };

        Card card1 = player.getHand().getCards().get(2);
        Card card2 = player.getHand().getCards().get(3);
        Card card3 = player.getHand().getCards().get(4);
        Card card4 = player.getHand().getCards().get(5);

        int oldHandSize = player.getHand().getSize();
        List<Card> cards = player.dealCards(indexes);
        
        assertEquals(indexes.size(), cards.size());
        assertEquals(oldHandSize - indexes.size(), player.getHand().getSize());
        assertTrue(card1.equals(cards.get(0)));
        assertTrue(card2.equals(cards.get(1)));
        assertTrue(card3.equals(cards.get(2)));
        assertTrue(card4.equals(cards.get(3)));
    }
}
