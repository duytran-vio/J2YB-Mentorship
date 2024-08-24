package j2yb.dam.StorageItem;

import j2yb.dam.User.User;
import lombok.Getter;

@Getter
public abstract class StorageItem {
    private static int idCounter = 0;
    private Integer id;
    private String name;
    private String path;
    private User owner;

    public StorageItem(String name, User owner) {
        this.id = idCounter++;
        this.name = name;
        this.owner = owner;
    }

    public void rename(String newName) {
        if (newName == null || newName.trim().isEmpty()) {
            throw new IllegalArgumentException("Name cannot be null or empty");
        }
        this.name = newName;
    }
}
