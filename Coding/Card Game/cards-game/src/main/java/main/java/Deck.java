package main.java;

import java.util.ArrayList;
import java.util.List;

import lombok.Getter;
import lombok.Setter;
import main.java.utils.RankType;
import main.java.utils.SuitType;

@Getter
@Setter
public class Deck {
    private List<Card> cards;

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
            throw new IllegalStateException("No card at index " + index);
        }
        return cards.remove(index);
    }

    public List<Card> getCards(List<Integer> indexes) {
        List<Card> resultCards = new ArrayList<>();
        indexes.sort((first, second) -> second - first);
        for (int i = indexes.size() - 1; i >= 0; i--) {
            int index = indexes.get(i);
            if (cards.size() <= index) {
                throw new IllegalStateException("No card at index " + index);
            }
            resultCards.add(cards.remove(index));
        }
        return resultCards;
    }
}
