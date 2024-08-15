package main.java;

import java.util.ArrayList;
import java.util.LinkedHashSet;
import java.util.List;
import java.util.Set;
import java.util.function.Predicate;

import lombok.Getter;
import lombok.Setter;
import main.java.utils.RankType;
import main.java.utils.SuitType;

@Getter
@Setter
public class Deck {
    protected List<Card> cards;

    public Deck(){
        this.cards = new ArrayList<Card>();
        for (SuitType suit : SuitType.values()) {
            for (RankType rank : RankType.values()) {
                cards.add(Card.create(rank, suit));
            }
        }
    }

    public void shuffle() {
        for (int i = 0; i < cards.size(); i++) {
            int randomIndex = (int) (Math.random() * cards.size());
            Card temp = cards.get(i);
            cards.set(i, cards.get(randomIndex));
            cards.set(randomIndex, temp);
        }
    }

    public boolean isEmpty() {
        return cards.isEmpty();
    }

    public int getSize() {
        return cards.size();
    }

    public Card drawTopCard() {
        return this.drawCardAt(0);
    }

    public Card drawBottomCard() {
        return this.drawCardAt(cards.size() - 1);
    }

    public Card drawCardAt(int index) {
        if (cards.size() <= index) {
            throw new IllegalArgumentException("No card at index " + index);
        }
        return cards.remove(index);
    }

    public List<Card> drawCards(List<Integer> indexes) {
        List<Card> resultCards = new ArrayList<>();
        Set<Integer> picked = new LinkedHashSet<>();
        for(int i = 0; i < indexes.size(); i++) {
            int index = indexes.get(i);
            if (cards.size() <= index) {
                throw new IllegalArgumentException("No card at index " + index + ". Deck size: " + cards.size());
            }
            if (picked.contains(index)) {
                throw new IllegalArgumentException("Duplicate index: " + index);
            }
            resultCards.add(cards.get(index));
            picked.add(index);
        }
        indexes.sort((first, second) -> second - first);
        for (int i = indexes.size() - 1; i >= 0; i--) {
            int index = indexes.get(i);
            cards.remove(index);
        }
        return resultCards;
    }

    public Deck discardCardsWithCond(Predicate<Card> filter) {
        cards.removeIf(filter);
        return this;
    }
}
