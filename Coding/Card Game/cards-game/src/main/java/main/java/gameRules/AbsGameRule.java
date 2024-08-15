package main.java.gameRules;

import java.util.List;
import java.util.function.Predicate;

import lombok.Getter;
import main.java.Card;
import main.java.Deck;
import main.java.Player;

@Getter
public abstract class AbsGameRule {
    protected ConfigGameRule configGameRule;
    protected List<Player> players;
    protected Deck deck;
    protected Predicate<Card> deckFilter;

    public AbsGameRule() {
        configGameRule = new ConfigGameRule();
        setupConfigGameRule();
        setDeckFilter();
        deck = new Deck().discardCardsWithCond(deckFilter);
    }

    abstract protected void setupConfigGameRule();
    abstract protected void setDeckFilter();

}
