package j2yb.ddvio.dlinq.dtos;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.Getter;
import lombok.Setter;

@Data
@Getter
@Setter
@AllArgsConstructor
public class DListGetRequest {
    private Integer fromValue;
    private Integer toValue;
}
