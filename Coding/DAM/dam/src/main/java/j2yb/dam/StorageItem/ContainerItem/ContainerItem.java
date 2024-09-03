package j2yb.dam.StorageItem.ContainerItem;

import java.util.ArrayList;
import java.util.List;
import java.util.NoSuchElementException;

import j2yb.dam.StorageItem.StorageItem;
import j2yb.dam.StorageItem.StorageItemType;
import j2yb.dam.User.User;
import lombok.Getter;

@Getter
public class ContainerItem extends StorageItem {
    private List<StorageItem> items;

    public ContainerItem(String name, User owner, StorageItemType type) {
        super(name, owner, type);
        this.items = new ArrayList<>();
    }
    
    public void addItem(StorageItem item) {
        if (items.stream().anyMatch(i -> i.getName().equals(item.getName()))) {
            throw new IllegalArgumentException("Item with the same name already exists");
        }
        items.add(item);
        item.setParent(this);
    }

    public StorageItem getItemByIndex(String name) {
        StorageItem foundItem = null;
        for (int i = 0; i < items.size(); i++) {
            if (items.get(i).getName().equals(name)) {
                foundItem = items.get(i);
                break;
            }
        }
        return foundItem; 
    }

    public void removeItem(StorageItem item) {
        items.remove(item);
    }

    public void deleteItemByName(String name) {
        var foundItem = getItemByIndex(name);
        if (foundItem == null) {
            throw new NoSuchElementException("Item not exists");
        }
        foundItem.deleteInternal();
        removeItem(foundItem);
    }

    @Override
    public void deleteInternal() {
        items.forEach(StorageItem::deleteInternal);
        items.clear();
        super.deleteInternal();
    }

    @Override
    public String viewContent() {
        String str = "Name: " + this.getName() + '\n';
        for (int i = 1; i < items.size() + 1; i++) {
            var item = items.get(i - 1);
            str += String.format("\t%d. %s - %s\n", i, item.getType(), item.getName());
        }
        return str;
    }
}
