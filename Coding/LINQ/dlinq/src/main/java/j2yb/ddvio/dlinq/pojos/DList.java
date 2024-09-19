package j2yb.ddvio.dlinq.pojos;

import java.util.ArrayList;
import java.util.Comparator;
import java.util.List;
import java.util.function.Function;
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
    public <TResult> List<TResult> select(Function<Integer, TResult> function){
        var newList = new ArrayList<TResult>();
        for (var item: list){
            newList.add(function.apply(item));
        }
        return newList;
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

    @Override
    public Integer count(){
        return list.size();
    }

    @Override
    public IDLinq orderBy(Function<Integer, Integer> keyExtractor){
        var newList = new ArrayList<>(list);
        newList.sort(Comparator.comparingInt(keyExtractor::apply));
        return  new DList(newList);
    }

    @Override
    public IDLinq orderByDescending(Function<Integer, Integer> keyExtractor){
        var newList = new ArrayList<>(list);
        newList.sort((first, second) -> keyExtractor.apply(second) - keyExtractor.apply(first));
        return  new DList(newList);
    }
}
