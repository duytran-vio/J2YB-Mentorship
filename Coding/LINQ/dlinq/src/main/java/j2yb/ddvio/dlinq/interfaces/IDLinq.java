package j2yb.ddvio.dlinq.interfaces;

import java.util.List;
import java.util.function.Function;
import java.util.function.Predicate;

public interface IDLinq {
    List<Integer> selectAll();
    List<Integer> select(Function<Integer, Integer> function);
    IDLinq where(Predicate<Integer> predicate);
    Integer count();
}
