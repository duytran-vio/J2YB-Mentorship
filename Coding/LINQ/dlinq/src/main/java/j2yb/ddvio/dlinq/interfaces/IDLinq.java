package j2yb.ddvio.dlinq.interfaces;

import java.util.List;
import java.util.function.Function;
import java.util.function.Predicate;

public interface IDLinq {
    List<Integer> selectAll();
    <TResult> List<TResult> select(Function<Integer, TResult> function);
    IDLinq where(Predicate<Integer> predicate);
    Integer count();
    IDLinq orderBy(Function<Integer, Integer> keyExtractor);
    IDLinq orderByDescending(Function<Integer, Integer> keyExtractor);
}
