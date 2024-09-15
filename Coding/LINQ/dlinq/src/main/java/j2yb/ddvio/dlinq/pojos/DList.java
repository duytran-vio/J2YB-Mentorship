package j2yb.ddvio.dlinq.pojos;

import java.util.ArrayList;
import java.util.List;
import java.util.function.Predicate;

import j2yb.ddvio.dlinq.interfaces.IDLinq;

public class DList implements IDLinq{
    private List<Integer> list;

    public DList() {
        list = new ArrayList<Integer>() {{
            add(1);
            add(2);
            add(3);
            add(4);
            add(5);
            add(6);
            add(7);
            add(8);
            add(9);
            add(10);
        }};
    }

    public DList(List<Integer> list) {
        this.list = list;
    }

    @Override
    public List<Integer> selectAll() {
        return this.list;
    }

    @Override
    public IDLinq where(Predicate<Integer> predicate) {
        var filterList = new ArrayList<Integer>();
        for (var item : list) {
            if (predicate.test(item)) {
                filterList.add(item);
            }
        }
        return new DList(filterList);
    }

    
}
