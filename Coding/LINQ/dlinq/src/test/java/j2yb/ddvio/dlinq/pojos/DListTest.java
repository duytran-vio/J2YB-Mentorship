package j2yb.ddvio.dlinq.pojos;

import static org.junit.jupiter.api.Assertions.*;
import java.util.Arrays;
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
}