package j2yb.dam.User;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;

import j2yb.dam.Permission.Permission;
import j2yb.dam.Permission.Role;
import j2yb.dam.StorageItem.StorageItem;
import j2yb.dam.StorageItem.StorageItemType;
import j2yb.dam.StorageItem.ContainerItem.Drive;
import j2yb.dam.StorageItem.ContainerItem.Folder;

import static org.assertj.core.api.Assertions.*;

public class UserTest {

    private User user;

    @BeforeEach
    public void setUp() {
        user = new User("John Doe");
    }

    @Test
    public void testNewUser() {
        assertThat(user.getName()).isEqualTo("John Doe");
    }        

    @Test
    public void testCreateDrive(){
        Drive drive = user.createDrive("DriveA");
        Role role = Permission.getRole(user, drive);
        assertThat(drive.getName()).isEqualTo("DriveA");
        assertThat(drive.getOwner()).isEqualTo(user);
        assertThat(user.getDrives()).contains(drive);
        assertThat(role).isEqualTo(Role.ADMIN);
    }

    @Test
    public void testUserHaveMultipleDrives(){
        user.createDrive("DriveA");
        user.createDrive("DriveB");
        assertThat(user.getDrives()).hasSize(2);
    }

    @Test
    public void testCreateItem_whenCreateInDriveHasNoFolder(){
        Drive drive = user.createDrive("DriveA");
        StorageItem rootFolder = user.createItem(drive, StorageItemType.FOLDER, "RootFolder");
        assertThat(drive.getItems()).contains(rootFolder);
        assertThat(rootFolder.getType()).isEqualTo(StorageItemType.FOLDER);
    }

    @Test
    public void testCreateItem_whenCreateFileInDrive_thenThrowException(){
        Drive drive = user.createDrive("DriveA");
        assertThatThrownBy(() -> user.createItem(drive, StorageItemType.FILE, "RootFolder"))
            .isInstanceOf(IllegalArgumentException.class)
            .hasMessage("Only folders can be added to a drive");
    }

    @Test
    public void testCreateItem_whenCreateFileAndFolderInRootFolder_thenSuccess(){
        Drive drive = user.createDrive("DriveA");
        Folder rootFolder = (Folder) user.createItem(drive, StorageItemType.FOLDER, "RootFolder");
        StorageItem file = user.createItem(rootFolder, StorageItemType.FILE, "FileA");
        StorageItem folder = user.createItem(rootFolder, StorageItemType.FOLDER, "FolderA");
        assertThat(rootFolder.getItems()).contains(file, folder);
        assertThat(file.getType()).isEqualTo(StorageItemType.FILE);
        assertThat(folder.getType()).isEqualTo(StorageItemType.FOLDER);
    }

    @Test
    public void testCreateItem_whenUserNotHavePermission_thenThrowException(){
        Drive drive = user.createDrive("DriveA");
        User user2 = new User("Jane Doe");
        assertThatThrownBy(() -> user2.createItem(drive, StorageItemType.FOLDER, "RootFolder"))
            .isInstanceOf(IllegalArgumentException.class)
            .hasMessage("User does not have permission to add item");
    }

    @Test
    public void testViewItem_whenViewDriveHasSubFolder_thenReturnListRootFolderStr(){
        Drive drive = user.createDrive("DriveA");
    }
        
}
