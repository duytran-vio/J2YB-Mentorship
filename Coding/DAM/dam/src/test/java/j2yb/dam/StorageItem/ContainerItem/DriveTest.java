package j2yb.dam.StorageItem.ContainerItem;

import static org.assertj.core.api.Assertions.*;

import org.junit.jupiter.api.Test;

import j2yb.dam.StorageItem.File;

public class DriveTest {
    @Test
    public void testNewDrive() {
        Drive drive = new Drive("C:", null);
        assertThat(drive.getName()).isEqualTo("C:");
    }

    @Test
    public void testAddItem() {
        Drive drive = new Drive("C:", null);
        Folder rootFolder = new Folder("item", null);
        drive.addItem(rootFolder);
        assertThat(drive.getItems()).hasSize(1);
    }

    @Test
    public void testAddItem_WhenAddDrive_ThenThrowIllegalArgumentException() {
        Drive drive = new Drive("C:", null);
        Drive drive2 = new Drive("D:", null);
        assertThatThrownBy(() -> drive.addItem(drive2))
            .isInstanceOf(IllegalArgumentException.class)
            .hasMessage("Only folders can be added to a drive");
    }

    @Test
    public void testAddItem_WhenAddFile_ThenThrowIllegalArgumentException() {
        Drive drive = new Drive("C:", null);
        File file = new File("item", null, null);
        assertThatThrownBy(() -> drive.addItem(file))
            .isInstanceOf(IllegalArgumentException.class)
            .hasMessage("Only folders can be added to a drive");
    }

    @Test
    public void testAddItem_WhenExistFolderName_ThenThrowIllegalArgumentException() {
        Drive drive = new Drive("C:", null);
        Folder rootFolder = new Folder("item", null);
        drive.addItem(rootFolder);
        Folder rootFolder2 = new Folder("item", null);
        assertThatThrownBy(() -> drive.addItem(rootFolder2))
            .isInstanceOf(IllegalArgumentException.class)
            .hasMessage("Item with the same name already exists");
    }

    @Test
    public void testGetItems() {
        Drive drive = new Drive("C:", null);
        Folder rootFolder = new Folder("item", null);
        drive.addItem(rootFolder);
        assertThat(drive.getItems()).contains(rootFolder);
    }

    @Test
    public void testRename() {
        Drive drive = new Drive("C:", null);
        drive.rename("D:");
        assertThat(drive.getName()).isEqualTo("D:");
    }

    @Test
    public void testDeleteSelf_whenHasSubFolder_ThenAllItemsDeleted() {
        Drive drive = new Drive("C:", null);
        Folder rootFolder = new Folder("item", null);
        drive.addItem(rootFolder);
        drive.deleteSelf();
        assertThat(drive.isDeleted()).isTrue();
        assertThat(rootFolder.isDeleted()).isTrue();
    }

    @Test
    public void testDeleteSelf_whenDriveAlreadyDeleted_thenThrowIllegalArgumentException() {
        Drive drive = new Drive("C:", null);
        drive.deleteSelf();
        assertThatThrownBy(() -> drive.deleteSelf())
            .isInstanceOf(IllegalArgumentException.class)
            .hasMessage("Item is already deleted");
    }

    @Test
    public void testViewContent_whenHasSubFolder_thenReturnDriveContent() {
        Drive drive = new Drive("C:", null);
        Folder rootFolder = new Folder("item", null);
        Folder rootFolder2 = new Folder("item2", null);
        drive.addItem(rootFolder);
        drive.addItem(rootFolder2);
        String expected = "Name: C:\n\t1. FOLDER - item\n\t2. FOLDER - item2\n";
        assertThat(drive.viewContent()).isEqualTo(expected);
    }
}
