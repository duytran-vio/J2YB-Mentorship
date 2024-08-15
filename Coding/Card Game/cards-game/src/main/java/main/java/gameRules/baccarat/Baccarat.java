package main.java.gameRules.baccarat;

import main.java.gameRules.AbsGameRule;
import main.java.utils.RankType;

public class Baccarat extends AbsGameRule {
    
    public Baccarat(){
        super();
        
    }

    protected void setupConfigGameRule() {
        configGameRule.setMaxPlayers(26);
        configGameRule.setMinPlayers(2);
        configGameRule.setCardsFirstDealEachPlayer(3);
        configGameRule.setMaxCardsEachPlayer(3);
    }

    @Override
    protected void setDeckFilter() {
        deckFilter = card -> card.getRank() == RankType.TEN || card.getRank() == RankType.JACK || card.getRank() == RankType.QUEEN || card.getRank() == RankType.KING;
    }
}
