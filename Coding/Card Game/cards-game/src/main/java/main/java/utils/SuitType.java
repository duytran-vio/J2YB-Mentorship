package main.java.utils;

public enum SuitType {
    HEARTS("\u2665"),   // ♥
    DIAMONDS("\u2666"), // ♦
    CLUBS("\u2663"),    // ♣
    SPADES("\u2660");   // ♠

    private final String symbol;

    SuitType(String symbol) {
        this.symbol = symbol;
    }

    public String getSymbol() {
        return symbol;
    }
}
