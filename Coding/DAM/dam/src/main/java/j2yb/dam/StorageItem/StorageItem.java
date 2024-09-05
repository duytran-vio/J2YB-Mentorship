package j2yb.dam.StorageItem;

import j2yb.dam.StorageItem.ContainerItem.ContainerItem;
import j2yb.dam.StorageItem.ContainerItem.Drive;
import j2yb.dam.StorageItem.ContainerItem.Folder;
import j2yb.dam.User.User;
import lombok.Getter;

@Getter
public abstract class StorageItem {
    private static int idCounter = 0;
    private Integer id;
    private String name;
    private String path;
    private User owner;
    private ContainerItem parent;
    private boolean isDeleted = false;
    private StorageItemType type;

    public StorageItem(String name, User owner, StorageItemType type) {
        this.id = idCounter++;
        this.name = name;
        this.owner = owner;
        this.type = type;
    }

    public static StorageItem createItemFactory(String name, User owner, StorageItemType type){
        switch (type){
            case FILE:
                return new File(name, "", owner);
            case FOLDER:
                return new Folder(name, owner);
            case DRIVE:
                return new Drive(name, owner);
            default:
                throw new IllegalArgumentException("Invalid type");
        }
    }

    public void rename(String newName) {
        if (newName == null || newName.trim().isEmpty()) {
            throw new IllegalArgumentException("Name cannot be null or empty");
        }
        this.name = newName;
    }

    public void setParent(ContainerItem parent) {
        this.parent = parent;
    }

    public void deleteSelf(){
        if (isDeleted){
            throw new IllegalArgumentException("Item is already deleted");
        }
        if(this.parent != null){
            this.parent.removeItem(this);
        }
        deleteInternal();
    }

    public void deleteInternal(){
        this.parent = null;
        this.isDeleted = true;
    }

    public abstract String viewContent();
}
