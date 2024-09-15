package j2yb.ddvio.dlinq.interfaces;

import java.util.List;
import java.util.function.Predicate;

public interface IDLinq {
    List<Integer> selectAll();
    IDLinq where(Predicate<Integer> predicate);
}
