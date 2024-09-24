package j2yb.ddvio.dlinq.pojos;

import java.util.ArrayList;
import java.util.Comparator;
import java.util.HashMap;
import java.util.List;
import java.util.function.Function;
import java.util.function.Predicate;

public class DList{
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

    public List<Integer> selectAll() {
        return this.list;
    }

    public <TResult> List<TResult> select(Function<Integer, TResult> function){
        var newList = new ArrayList<TResult>();
        for (var item: list){
            newList.add(function.apply(item));
        }
        return newList;
    }

    public DList where(Predicate<Integer> predicate) {
        var filterList = new ArrayList<Integer>();
        for (var item : list) {
            if (predicate.test(item)) {
                filterList.add(item);
            }
        }
        return new DList(filterList);
    }

    public Integer count(Predicate<Integer> predicate) {
        var count = 0;
        for (var item : list) {
            if (predicate.test(item)) {
                count++;
            }
        }
        return count;
    }

    public Integer first(Predicate<Integer> predicate) {
        for (var item : list) {
            if (predicate.test(item)) {
                return item;
            }
        }
        return null;
    }

    public boolean any(Predicate<Integer> predicate) {
        for (var item : list) {
            if (predicate.test(item)) {
                return true;
            }
        }
        return false;
    }

    public boolean all(Predicate<Integer> predicate) {
        for (var item : list) {
            if (!predicate.test(item)) {
                return false;
            }
        }
        return true;
    }

    public DList orderBy(Function<Integer, Integer> keyExtractor){
        var newList = new ArrayList<>(list);
        newList.sort(Comparator.comparingInt(keyExtractor::apply));
        return new DList(newList);
    }

    public DList orderByDescending(Function<Integer, Integer> keyExtractor){
        var newList = new ArrayList<>(list);
        newList.sort((first, second) -> keyExtractor.apply(second) - keyExtractor.apply(first));
        return new DList(newList);
    }

    public HashMap<Integer, List<Integer>> groupBy(Function<Integer, Integer> keyExtractor){
        var map = new HashMap<Integer, List<Integer>>();
        for (var item : list) {
            var key = keyExtractor.apply(item);
            if (!map.containsKey(key)) {
                map.put(key, new ArrayList<>());
            }
            map.get(key).add(item);
        }
        return map;
    }

    public HashMap<Integer, Integer> dmax(Function<Integer, Integer> keyExtractor){
        var map = new HashMap<Integer, Integer>();
        for(var item : list){
            var key = keyExtractor.apply(item);
            if (!map.containsKey(key)){
                map.put(key, item);
            }
            else{
                if (item > map.get(key)){
                    map.put(key, item);
                }
            }
        }
        return map;
    }

    public HashMap<Integer, Integer> dmin(Function<Integer, Integer> keyExtractor){
        var map = new HashMap<Integer, Integer>();
        for(var item : list){
            var key = keyExtractor.apply(item);
            if (!map.containsKey(key)){
                map.put(key, item);
            }
            else{
                if (item < map.get(key)){
                    map.put(key, item);
                }
            }
        }
        return map;
    }

    public HashMap<Integer, Integer> dcount(Function<Integer, Integer> keyExtractor){
        var map = groupBy(keyExtractor);
        var countMap = new HashMap<Integer, Integer>();
        for (var key : map.keySet()){
            countMap.put(key, map.get(key).size());
        }
        return countMap;
    }

    public HashMap<Integer, Integer> dsum(Function<Integer, Integer> keyExtractor){
        var map = groupBy(keyExtractor);
        var sumMap = new HashMap<Integer, Integer>();
        for (var key : map.keySet()){
            var sum = 0;
            for (var item : map.get(key)){
                sum += item;
            }
            sumMap.put(key, sum);
        }
        return sumMap;
    }

}
