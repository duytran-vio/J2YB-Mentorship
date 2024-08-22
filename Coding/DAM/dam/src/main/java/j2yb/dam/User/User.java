package j2yb.dam.User;

import java.util.ArrayList;
import java.util.List;

import j2yb.dam.Permission.*;
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
        Drive newDrive = new Drive(driveName, this);
        drives.add(newDrive);
        Permission.addPermission(this, newDrive, Role.ADMIN);
        return newDrive;
    }
}
