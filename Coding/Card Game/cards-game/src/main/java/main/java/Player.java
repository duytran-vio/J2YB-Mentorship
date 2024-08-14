package main.java;

import java.util.List;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class Player {
    private String name;
    private Hand hand;
    
    public Player(String name) {
        this.name = name;
        this.hand = new Hand();
    }

    public Player(String name, Hand hand) {
        this.name = name;
        this.hand = hand;
    }

    public void receiveCards(List<Card> cards) {
        hand.addAll(cards);
    }

	public List<Card> dealCards(List<Integer> indexes) {
		return hand.drawCards(indexes);
	}

    public String showHand(){
        return hand.show();
    }

}
