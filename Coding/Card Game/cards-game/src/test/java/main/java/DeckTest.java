package main.java;

import static org.junit.jupiter.api.Assertions.assertEquals;

import java.util.ArrayList;
import java.util.List;

import org.junit.jupiter.api.Test;

public class DeckTest {
    @Test
    void testCreateDeck_ThenReturnCorrectSize() {
        Deck deck = new Deck();
        assertEquals(52, deck.getSize());
    }

    @Test
    void testShuffleDeck_ThenReturnDifferentOrder() {
        Deck deck = new Deck();
        Deck shuffledDeck = new Deck();
        shuffledDeck.shuffle();

        boolean isSameOrder = true;
        for (int i = 0; i < deck.getCards().size(); i++) {
            if (deck.getCards().get(i) != shuffledDeck.getCards().get(i)) {
                isSameOrder = false;
                break;
            }
        }

        assertEquals(false, isSameOrder);
    }

    @Test 
    void testIsEmpty_ThenReturnTrue() {
        Deck deck = new Deck();
        for (int i = 0; i < 52; i++) {
            deck.drawTopCard();
        }

        assertEquals(true, deck.isEmpty());
    }

    @Test
    void testDrawTopCard_ThenReturnTopCard() {
        Deck deck = new Deck();
        Card topCard = deck.getCards().get(0);
        Card returnedCard = deck.drawTopCard();

        assertEquals(topCard, returnedCard);
        assertEquals(51, deck.getCards().size());
    }

    @Test
    void testDrawBottomCard_ThenReturnBottomCard() {
        Deck deck = new Deck();
        Card bottomCard = deck.getCards().get(deck.getCards().size() - 1);
        Card returnedCard = deck.drawBottomCard();

        assertEquals(bottomCard, returnedCard);
        assertEquals(51, deck.getCards().size());
    }

    @Test
    void testDrawCardAt_ThenReturnCardAtSpecifiedIndex() {
        Deck deck = new Deck();
        Card cardAt5 = deck.getCards().get(5);
        Card returnedCard = deck.drawCardAt(5);

        assertEquals(cardAt5, returnedCard);
        assertEquals(51, deck.getSize());
    }

    @Test 
    void testDrawCardAt_WhenIndexIsOutOfBound_ThenThrowException() {
        Deck deck = new Deck();
        try {
            deck.drawCardAt(52);
        } catch (IllegalStateException e) {
            assertEquals("No card at index 52", e.getMessage());
        }
    }

    @Test
    void testGetCards_WhenIndexesAreValid_ThenReturnCardsAtSpecifiedIndexes() {
        Deck deck = new Deck();
        Card cardAt5 = deck.getCards().get(5);
        Card cardAt10 = deck.getCards().get(10);
        Card cardAt15 = deck.getCards().get(15);

        List<Integer> indexes = new ArrayList<>();
        indexes.add(5);
        indexes.add(10);
        indexes.add(15);
        List<Card> returnedCards = deck.getCards(indexes);

        assertEquals(cardAt5.show(), returnedCards.get(0).show());
        assertEquals(cardAt10.show(), returnedCards.get(1).show());
        assertEquals(cardAt15.show(), returnedCards.get(2).show());
        assertEquals(49, deck.getSize());
    }
}
