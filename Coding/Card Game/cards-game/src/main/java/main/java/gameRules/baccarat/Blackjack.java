package main.java.gameRules.baccarat;

import main.java.gameRules.AbsGameRule;

public class Blackjack extends AbsGameRule {
    
    public Blackjack(){
        super();
        
    }

    protected void setupConfigGameRule() {
        configGameRule.setMaxPlayers(7);
        configGameRule.setMinPlayers(2);
        configGameRule.setCardsFirstDealEachPlayer(2);
        configGameRule.setMaxCardsEachPlayer(5);
    }

    @Override
    protected void setDeckFilter() {
        deckFilter = card -> false;
    }
    
}
