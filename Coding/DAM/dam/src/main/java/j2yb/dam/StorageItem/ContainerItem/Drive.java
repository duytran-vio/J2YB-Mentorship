package j2yb.dam.StorageItem.ContainerItem;

import j2yb.dam.StorageItem.StorageItem;
import j2yb.dam.User.User;

public class Drive extends ContainerItem {

    public Drive(String name, User owner) {
        super(name, owner);
    }

    @Override
    public void addItem(StorageItem item) {
        if (item instanceof Folder) {
            super.addItem(item);
            return;
        }
        throw new IllegalArgumentException("Only folders can be added to a drive");
    }
    
}
