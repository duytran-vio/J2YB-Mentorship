package j2yb.ddvio.dlinq.pojos;

import static org.junit.jupiter.api.Assertions.*;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.function.Function;
import java.util.function.Predicate;

import org.junit.jupiter.api.Test;

public class DListTest {
    @Test
    public void testSelectAllWithCustomList() {
        // Arrange
        List<Integer> customList = Arrays.asList(10, 20, 30);
        DList dList = new DList(customList);

        // Act
        List<Integer> result = dList.selectAll();

        // Assert
        assertEquals(customList, result);
    }

    @Test
    public void testSelectAllWithEmptyList() {
        // Arrange
        DList dList = new DList(List.of());

        // Act
        List<Integer> result = dList.selectAll();

        // Assert
        assertEquals(result.size(), 0);
    }

    @Test
    public void testSelect(){
        // Arrange
        DList dList = new DList();
        var oldList = dList.selectAll();
        Function<Integer, Integer> doubleValue = x -> x * 2;

        // Act
        var result = dList.select(doubleValue);

        // Assert
        assertEquals(result.size(), oldList.size());
        assertEquals(result.get(0), oldList.get(0) * 2);
        assertEquals(result.get(1), oldList.get(1) * 2);
    }

    @Test
    public void testSelect_returnDoubleType(){
        // Arrange
        DList dList = new DList(List.of(1, 3, 5, 7));
        var oldList = dList.selectAll();
        Function<Integer, Double> halfValue = x -> x / 2.0;

        // Act
        var result = dList.select(halfValue);

        // Assert
        assertEquals(result.size(), oldList.size());
        assertEquals(result.get(0), oldList.get(0) / 2.0);
        assertEquals(result.get(1), oldList.get(1) / 2.0);
    }

    @Test
    public void testWhereWithEvenNumbers() {
        // Arrange
        DList dList = new DList();
        Predicate<Integer> isEven = x -> x % 2 == 0;
        List<Integer> expected = Arrays.asList(2, 4, 6, 8, 10);

        // Act
        List<Integer> result = dList.where(isEven).selectAll();

        // Assert
        assertEquals(expected, result);
    }

    @Test
    public void testWhereWithGreaterThanThree() {
        // Arrange
        DList dList = new DList();
        List<Integer> expected = Arrays.asList(4, 5, 6, 7, 8, 9, 10);
        Predicate<Integer> greaterThanThree = x -> x > 3;

        // Act
        List<Integer> result = dList.where(greaterThanThree).selectAll();

        // Assert
        assertEquals(expected, result);
    }

    @Test
    public void testWhereWithEmptyList() {
        // Arrange
        DList dList = new DList(Arrays.asList());
        Predicate<Integer> isEven = x -> x % 2 == 0;

        // Act
        List<Integer> result = dList.where(isEven).selectAll();

        // Assert
        assertEquals(result.size(), 0);
    }

    @Test
    public void testWhereWithNoMatch() {
        // Arrange
        DList dList = new DList();
        Predicate<Integer> greaterThanFive = x -> x > 10;

        // Act
        List<Integer> result = dList.where(greaterThanFive).selectAll();

        // Assert
        assertEquals(result.size(), 0);
    }

    @Test
    public void testWhere_whenInRangeValues() {
        // Arrange
        DList dList = new DList();
        List<Integer> expected = Arrays.asList(3, 4, 5, 6, 7);
        Predicate<Integer> inRange = x -> x >= 3 && x <= 7;

        // Act
        List<Integer> result = dList.where(inRange).selectAll();

        // Assert
        assertEquals(expected, result);
    }

    @Test
    public void testOrderBy() {
        // Arrange
        DList dList = new DList(List.of(7,3,4,5,7,6));
        List<Integer> expected = Arrays.asList(3,4,5,6,7,7);

        // Act
        List<Integer> result = dList.orderBy(x -> x).selectAll();

        // Assert
        assertEquals(expected, result);
    }

    @Test
    public void testOrderByDescending() {
        // Arrange
        DList dList = new DList(List.of(7,3,4,5,7,6));
        List<Integer> expected = Arrays.asList(7, 7, 6, 5, 4, 3);

        // Act
        List<Integer> result = dList.orderByDescending(x -> x).selectAll();

        // Assert
        assertEquals(expected, result);
    }

    @Test
    public void testCountWithEvenNumbers() {
        // Arrange
        DList dList = new DList();
        Predicate<Integer> isEven = x -> x % 2 == 0;
        int expectedCount = 5;

        // Act
        int result = dList.count(isEven);

        // Assert
        assertEquals(expectedCount, result);
    }

    @Test
    public void testCountWithGreaterThanThree() {
        // Arrange
        DList dList = new DList();
        Predicate<Integer> greaterThanThree = x -> x > 3;
        int expectedCount = 7;

        // Act
        int result = dList.count(greaterThanThree);

        // Assert
        assertEquals(expectedCount, result);
    }

    @Test
    public void testGroupByEvenOdd() {
        // Arrange
        DList dList = new DList();
        Function<Integer, Integer> evenOddKeyExtractor = x -> x % 2;
        HashMap<Integer, List<Integer>> expected = new HashMap<>();
        expected.put(0, Arrays.asList(2, 4, 6, 8, 10));
        expected.put(1, Arrays.asList(1, 3, 5, 7, 9));

        // Act
        HashMap<Integer, List<Integer>> result = dList.groupBy(evenOddKeyExtractor);

        // Assert
        assertEquals(expected, result);
    }

    @Test
    public void testGroupByMultipleKeys() {
        // Arrange
        DList dList = new DList(List.of(1, 2, 3, 4, 5, 6, 7, 8, 9, 10));
        Function<Integer, Integer> keyExtractor = x -> x % 3;
        HashMap<Integer, List<Integer>> expected = new HashMap<>();
        expected.put(0, Arrays.asList(3, 6, 9));
        expected.put(1, Arrays.asList(1, 4, 7, 10));
        expected.put(2, Arrays.asList(2, 5, 8));

        // Act
        HashMap<Integer, List<Integer>> result = dList.groupBy(keyExtractor);

        // Assert
        assertEquals(expected, result);
    }

    @Test
    public void testAnyWithEvenNumbers() {
        // Arrange
        DList dList = new DList();
        Predicate<Integer> isEven = x -> x % 2 == 0;

        // Act
        boolean result = dList.any(isEven);

        // Assert
        assertTrue(result);
    }

    @Test
    public void testAnyWithGreaterThanTen() {
        // Arrange
        DList dList = new DList();
        Predicate<Integer> greaterThanTen = x -> x > 10;

        // Act
        boolean result = dList.any(greaterThanTen);

        // Assert
        assertFalse(result);
    }

    @Test
    public void testAllWithEvenNumbers() {
        // Arrange
        DList dList = new DList(List.of(2, 4, 6, 8, 10));
        Predicate<Integer> isEven = x -> x % 2 == 0;

        // Act
        boolean result = dList.all(isEven);

        // Assert
        assertTrue(result);
    }

    @Test
    public void testAllWithMixedNumbers() {
        // Arrange
        DList dList = new DList(List.of(2, 3, 6, 8, 10));
        Predicate<Integer> isEven = x -> x % 2 == 0;

        // Act
        boolean result = dList.all(isEven);

        // Assert
        assertFalse(result);
    }

    @Test
    public void testDmaxWithMultipleKeys() {
        // Arrange
        DList dList = new DList(List.of(1, 2, 3, 4, 5, 6, 7, 8, 9, 10));
        Function<Integer, Integer> keyExtractor = x -> x % 3;
        HashMap<Integer, Integer> expected = new HashMap<>();
        expected.put(0, 9);
        expected.put(1, 10);
        expected.put(2, 8);

        // Act
        HashMap<Integer, Integer> result = dList.dmax(keyExtractor);

        // Assert
        assertEquals(expected, result);
    }

    @Test
    public void testDminWithMultipleKeys() {
        // Arrange
        DList dList = new DList(List.of(1, 2, 3, 4, 5, 6, 7, 8, 9, 10));
        Function<Integer, Integer> keyExtractor = x -> x % 3;
        HashMap<Integer, Integer> expected = new HashMap<>();
        expected.put(0, 3);
        expected.put(1, 1);
        expected.put(2, 2);

        // Act
        HashMap<Integer, Integer> result = dList.dmin(keyExtractor);

        // Assert
        assertEquals(expected, result);
    }

    @Test
    public void testDcountWithMultipleKeys() {
        // Arrange
        DList dList = new DList(List.of(1, 2, 3, 4, 5, 6, 7, 8, 9, 10));
        Function<Integer, Integer> keyExtractor = x -> x % 3;
        HashMap<Integer, Integer> expected = new HashMap<>();
        expected.put(0, 3);
        expected.put(1, 4);
        expected.put(2, 3);

        // Act
        HashMap<Integer, Integer> result = dList.dcount(keyExtractor);

        // Assert
        assertEquals(expected, result);
    }

    @Test
    public void testDsumWithMultipleKeys() {
        // Arrange
        DList dList = new DList(List.of(1, 2, 3, 4, 5, 6, 7, 8, 9, 10));
        Function<Integer, Integer> keyExtractor = x -> x % 3;
        HashMap<Integer, Integer> expected = new HashMap<>();
        expected.put(0, 18); // 3+6+9
        expected.put(1, 22); // 1+4+7+10
        expected.put(2, 15); // 2+5+8

        // Act
        HashMap<Integer, Integer> result = dList.dsum(keyExtractor);

        // Assert
        assertEquals(expected, result);
    }
}