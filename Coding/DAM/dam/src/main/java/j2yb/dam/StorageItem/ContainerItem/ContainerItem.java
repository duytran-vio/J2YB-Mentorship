package j2yb.dam.StorageItem.ContainerItem;

import java.util.ArrayList;
import java.util.List;

import j2yb.dam.StorageItem.StorageItem;
import j2yb.dam.User.User;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class ContainerItem extends StorageItem {
    private List<StorageItem> items;

    public ContainerItem(String name, User owner) {
        super(name, owner);
        this.items = new ArrayList<>();
    }
    
    public void addItem(StorageItem item) {
        items.add(item);
    }
}
