package j2yb.ddvio.dlinq.controllers;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import j2yb.ddvio.dlinq.dtos.DListDto;
import j2yb.ddvio.dlinq.dtos.DListGetRequest;
import j2yb.ddvio.dlinq.services.DListService;
import lombok.AllArgsConstructor;

@RestController
@RequestMapping("/dlist")
@AllArgsConstructor
public class DListController {
    private final DListService dListService;
    
    @GetMapping("/all")
    public DListDto get(){
        return dListService.getAll();
    }

    @GetMapping
    public DListDto get(DListGetRequest request){
        return dListService.get(request);
    }
}
