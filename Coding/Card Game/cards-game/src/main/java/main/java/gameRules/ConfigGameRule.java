package main.java.gameRules;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class ConfigGameRule {
    private int maxPlayers;
    private int minPlayers;
    private int cardsFirstDealEachPlayer;
    private int maxCardsEachPlayer;
}
