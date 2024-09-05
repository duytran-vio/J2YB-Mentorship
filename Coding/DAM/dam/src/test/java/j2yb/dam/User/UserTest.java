package j2yb.dam.User;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;

import j2yb.dam.Permission.Permission;
import j2yb.dam.Permission.Role;
import j2yb.dam.StorageItem.File;
import j2yb.dam.StorageItem.StorageItem;
import j2yb.dam.StorageItem.StorageItemType;
import j2yb.dam.StorageItem.ContainerItem.Drive;
import j2yb.dam.StorageItem.ContainerItem.Folder;

import static org.assertj.core.api.Assertions.*;

public class UserTest {

    private User user;
    private Drive oneDrive;
    private Folder oneDriveRootFolder1;
    private Folder oneDriveRootFolder2;
    private Folder oneDriveRootFolder1SubFolder1;
    private Folder oneDriveRootFolder1SubFolder2;
    private File oneDriveRootFolder1File1;
    private File oneDriveRootFolder1File2;
    private File oneDriveRootFolder1SubFolder1File1;

    @BeforeEach
    public void setUp() {
        user = new User("John Doe");
        oneDrive = user.createDrive("OneDrive");
        oneDriveRootFolder1 = (Folder) user.createItem(oneDrive, StorageItemType.FOLDER, "RootFolder1");
        oneDriveRootFolder2 = (Folder) user.createItem(oneDrive, StorageItemType.FOLDER, "RootFolder2");
        oneDriveRootFolder1SubFolder1 = (Folder) user.createItem(oneDriveRootFolder1, StorageItemType.FOLDER, "SubFolder1");
        oneDriveRootFolder1SubFolder2 = (Folder) user.createItem(oneDriveRootFolder1, StorageItemType.FOLDER, "SubFolder2");
        oneDriveRootFolder1File1 = (File) user.createItem(oneDriveRootFolder1, StorageItemType.FILE, "File1");
        oneDriveRootFolder1File2 = (File) user.createItem(oneDriveRootFolder1, StorageItemType.FILE, "File2");
        oneDriveRootFolder1SubFolder1File1 = (File) user.createItem(oneDriveRootFolder1SubFolder1, StorageItemType.FILE, "SubFolder1File1");

        oneDriveRootFolder1File1.changeContent("File1Content");
        oneDriveRootFolder1File2.changeContent("File2Content");
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
        assertThat(user.getDrives()).hasSize(3);
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
    public void testViewItem_whenViewFolder_thenReturnListSubItemStr(){
        Drive drive = user.createDrive("DriveA");
        Folder rootFolder = (Folder) user.createItem(drive, StorageItemType.FOLDER, "RootFolder");
        StorageItem file = user.createItem(rootFolder, StorageItemType.FILE, "FileA");
        Folder subfolder = (Folder)user.createItem(rootFolder, StorageItemType.FOLDER, "FolderA");
        StorageItem subFolder = user.createItem(subfolder, StorageItemType.FOLDER, "SubFolderA");
        String expectedContent = "Name: RootFolder\n\t1. FILE - FileA\n\t2. FOLDER - FolderA\n";

        String viewContent = user.viewItem(rootFolder);
        assertThat(viewContent).isEqualTo(expectedContent);
    }

    @Test 
    public void testViewItem_whenViewDriveContent_thenReturnListSubItemStr(){
        String expectedContent = "Name: OneDrive\n"
                                    + "\t1. FOLDER - RootFolder1\n"
                                    + "\t2. FOLDER - RootFolder2\n";
        String viewContent = user.viewItem(oneDrive);
        assertThat(viewContent).isEqualTo(expectedContent);
    }

    @Test
    public void testViewItem_whenViewFile_thenReturnFileContent(){
        String expectedContent = "Name: File1\n"
                                    + "Content: File1Content";
        String viewContent = user.viewItem(oneDriveRootFolder1File1);
        assertThat(viewContent).isEqualTo(expectedContent);
    }

    @Test
    public void testViewItem_whenUserNotHavePermission_thenThrowException(){
        Drive drive = user.createDrive("DriveA");
        Folder rootFolder = (Folder) user.createItem(drive, StorageItemType.FOLDER, "RootFolder");
        User user2 = new User("Jane Doe");
        assertThatThrownBy(() -> user2.viewItem(rootFolder))
            .isInstanceOf(IllegalArgumentException.class)
            .hasMessage("User does not have permission to view item");
    }

    @Test
    public void testDeleteItem_whenDeleteFile_thenDeleteFileSuccess(){
        user.deleteItem(oneDriveRootFolder1File1);
        assertThat(oneDriveRootFolder1.getItems()).doesNotContain(oneDriveRootFolder1File1);
        assertThat(oneDriveRootFolder1File1.isDeleted()).isTrue();
    }
     
    @Test
    public void testDeleteItem_whenDeleteFolder_thenDeleteFolderSuccess(){
        user.deleteItem(oneDriveRootFolder1);
        assertThat(oneDriveRootFolder1.isDeleted()).isTrue();
        assertThat(oneDriveRootFolder1File1.isDeleted()).isTrue();
        assertThat(oneDriveRootFolder1File2.isDeleted()).isTrue();
        assertThat(oneDriveRootFolder1SubFolder1.isDeleted()).isTrue();
        assertThat(oneDriveRootFolder1SubFolder1File1.isDeleted()).isTrue();
        assertThat(oneDriveRootFolder1SubFolder2.isDeleted()).isTrue();
        assertThat(oneDrive.getItems()).doesNotContain(oneDriveRootFolder1);
    }

    @Test
    public void testDeleteItem_whenDeleteDrive_thenDeleteDriveSuccess(){
        user.deleteItem(oneDrive);
        assertThat(oneDrive.isDeleted()).isTrue();
        assertThat(oneDriveRootFolder1.isDeleted()).isTrue();
        assertThat(oneDriveRootFolder1File1.isDeleted()).isTrue();
        assertThat(oneDriveRootFolder1File2.isDeleted()).isTrue();
        assertThat(oneDriveRootFolder1SubFolder1.isDeleted()).isTrue();
        assertThat(oneDriveRootFolder1SubFolder1File1.isDeleted()).isTrue();
        assertThat(oneDriveRootFolder1SubFolder2.isDeleted()).isTrue();
        assertThat(oneDriveRootFolder2.isDeleted()).isTrue();
        assertThat(user.getDrives()).doesNotContain(oneDrive);
    }

    @Test
    public void testDeleteItem_whenUserNotHavePermission_thenThrowException(){
        Drive drive = user.createDrive("DriveA");
        Folder rootFolder = (Folder) user.createItem(drive, StorageItemType.FOLDER, "RootFolder");
        User user2 = new User("Jane Doe");
        assertThatThrownBy(() -> user2.deleteItem(rootFolder))
            .isInstanceOf(IllegalArgumentException.class)
            .hasMessage("User does not have permission to delete item");
    }

    @Test
    public void testDeleteItem_WhenAlreadyDeletedItem_ThenThrowNoSuchElementException(){
        user.deleteItem(oneDriveRootFolder1);
        assertThatThrownBy(() -> user.deleteItem(oneDriveRootFolder1))
            .isInstanceOf(IllegalArgumentException.class)
            .hasMessage("Item is already deleted");
    }
        
}
