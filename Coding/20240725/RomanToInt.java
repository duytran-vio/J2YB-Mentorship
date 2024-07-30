import java.util.HashMap;
import java.util.List;
import java.util.Scanner;

public class RomanToInt {
    private static Scanner scanner = new Scanner(System.in);
    private static HashMap<Character, Integer> romanMap;
    private static List<String> validSubstractive;

    public static void main(String[] args) {
        String roman = "";
        initRomanDictionary();
        do {
            System.out.println("Input roman number: ");
            roman = scanner.nextLine();
        } 
        while (!isValidRoman(roman));

        Integer result = romanToInt(roman);
        System.out.println("Result: " + result);
    }

    private static void initRomanDictionary() {
        romanMap = new HashMap<Character, Integer>() {
        {
            put('I', 1);
            put('V', 5);
            put('X', 10);
            put('L', 50);
            put('C', 100);
            put('D', 500);
            put('M', 1000);
        }
        };

        validSubstractive = List.of("IV", "IX", "XL", "XC", "CD", "CM");
    }

    private static boolean isValidRoman(String roman) {
        for (char c : roman.toCharArray()) {
            // Check if the character is a valid roman number
            if (!romanMap.containsKey(c)) { 
                return false;
            }
        }
        
        for(int i =  0; i < roman.length() - 1; i++) {
            char current = roman.charAt(i);
            char next = roman.charAt(i + 1);
            if(isLowerRoman(current, next)){
                // Check if the substraction is valid
                if(!validSubstractive.contains("" + current + next)){ 
                    return false;
                }

                //  only place one smaller numeral in front of a larger one for subtractive purposes
                if(i > 0 && (isLowerRoman(roman.charAt(i - 1), current) || roman.charAt(i - 1) == current)){ 
                    return false;
                }
            }
        }
        return true;
    }

    private static boolean isLowerRoman(char first, char second){
        return romanMap.get(first) < romanMap.get(second);
    }

    private static Integer romanToInt(String roman) {
        Integer result = 0;
        for(int i = 0; i < roman.length(); i++){
            char current = roman.charAt(i);
            if (i > 0 && isLowerRoman(roman.charAt(i - 1), current)) {
                result -= 2 * romanMap.get(roman.charAt(i - 1));
            }
            result += romanMap.get(current);
        }
        return result;
    }
}