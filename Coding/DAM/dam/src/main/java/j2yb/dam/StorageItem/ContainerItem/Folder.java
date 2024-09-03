package j2yb.dam.StorageItem.ContainerItem;

import j2yb.dam.StorageItem.StorageItem;
import j2yb.dam.StorageItem.StorageItemType;
import j2yb.dam.User.User;

public class Folder extends ContainerItem {

    public Folder(String name, User owner) {
        super(name, owner, StorageItemType.FOLDER);
    }

    @Override
    public void addItem(StorageItem item) {
        if (item instanceof Drive) {
            throw new IllegalArgumentException("Drives cannot be added to a folder");
        }
        super.addItem(item);
    }
    
}
