import java.util.HashMap;
import java.util.List;
import java.util.Scanner;

public class IntToRoman {

    private static Scanner scanner = new Scanner(System.in);
    private static HashMap<Integer, String> romanMap;
    private static List<Integer> romanIntValues;

    public static void main(String[] args) {
        initRomanDictionary();
        System.out.println("Input integer number: ");
        Integer number = scanner.nextInt();

        String romanResult = intToRoman(number);
        System.out.println("Result: " + romanResult);
    }

    private static void initRomanDictionary() {
        romanMap = new HashMap<>() {
            {
                put(1, "I");
                put(4, "IV");
                put(5, "V");
                put(9, "IX");
                put(10, "X");
                put(40, "XL");
                put(50, "L");
                put(90, "XC");
                put(100, "C");
                put(400, "CD");
                put(500, "D");
                put(900, "CM");
                put(1000, "M");
            }
        };
        romanIntValues = List.of(1, 4, 5, 9, 10, 40, 50, 90, 100, 400, 500, 900, 1000);
    }

    private static String intToRoman(Integer number){
        String romanResult = "";
        while(number > 0){
            Integer closest = findClosestRoman(number);
            romanResult += romanMap.get(closest);
            number -= closest;
        }
        return romanResult;
    }

    private static Integer findClosestRoman(Integer number){
        for(int i = romanIntValues.size() - 1; i >= 0; i--){
            if(romanIntValues.get(i) <= number){
                return romanIntValues.get(i);
            }
        }
        return 0;
    }
}
