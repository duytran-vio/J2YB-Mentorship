package j2yb.ddvio.dlinq.services;

import java.util.function.Predicate;

import org.springframework.stereotype.Service;

import j2yb.ddvio.dlinq.dtos.DListDto;
import j2yb.ddvio.dlinq.dtos.DListGetRequest;
import j2yb.ddvio.dlinq.pojos.DList;

@Service
public class DListService {
    private DList dList;

    public DListService() {
        dList = new DList();
    }

    public DListDto getAll() {
        var list = dList.selectAll();
        return new DListDto(list);
    }

    public DListDto get(DListGetRequest request) {
        if (request == null){
            return this.getAll();
        }

        var fromValue = request.getFromValue();
        var toValue = request.getToValue();
        Predicate<Integer> predicate = (item) -> item >= fromValue && item <= toValue;
        var list = dList.where(predicate).selectAll();
        return new DListDto(list);
    }
}
