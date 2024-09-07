package j2yb.dam.User;

import java.util.ArrayList;
import java.util.List;

import j2yb.dam.Permission.*;
import j2yb.dam.StorageItem.StorageItem;
import j2yb.dam.StorageItem.StorageItemType;
import j2yb.dam.StorageItem.ContainerItem.ContainerItem;
import j2yb.dam.StorageItem.ContainerItem.Drive;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class User {
    private static int idCounter = 0;
    private Integer id;
    private String name;
    private List<Drive> drives;
    
    public User(String name){
        this.id = idCounter++;
        this.name = name;
        this.drives = new ArrayList<>();
    }

    public Drive createDrive(String driveName) {
        Drive newDrive = (Drive)StorageItem.createItemFactory(driveName, this, StorageItemType.DRIVE);
        drives.add(newDrive);
        Permission.addPermission(this, newDrive, Role.ADMIN);
        return newDrive;
    }

    public String viewItem(StorageItem item) {
        if (!Permission.canView(this, item)){
            throw new IllegalArgumentException("User does not have permission to view item");
        }
        return item.viewContent();
    }

    public StorageItem createItem(ContainerItem containerItem, StorageItemType itemType, String string) {
        if (!Permission.canAlter(this, containerItem)){
            throw new IllegalArgumentException("User does not have permission to add item");
        }
        StorageItem newItem = StorageItem.createItemFactory(string, this, itemType);
        containerItem.addItem(newItem);
        Permission.copyPermissions(this, containerItem, newItem);
        return newItem;
    }

    public void deleteItem(StorageItem item) {
        if (!Permission.canAlter(this, item)){
            throw new IllegalArgumentException("User does not have permission to delete item");
        }
        item.deleteSelf();
        if (item.getType() == StorageItemType.DRIVE){
            drives.remove(item);
        }
    }

    public void sharePermission(StorageItem item, User user, Role role) {
        if (!Permission.canShare(this, item)){
            throw new IllegalArgumentException("User does not have permission to share item");
        }
        Permission.grantPermission(user, item, role);
    }
}
