package j2yb.ddvio.dlinq.pojos;

import static org.junit.jupiter.api.Assertions.*;
import java.util.Arrays;
import java.util.List;
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
        DList dList = new DList(Arrays.asList());

        // Act
        List<Integer> result = dList.selectAll();

        // Assert
        assertEquals(result.size(), 0);
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
}