package j2yb.dam.StorageItem.ContainerItem;

import static org.assertj.core.api.Assertions.assertThat;
import static org.assertj.core.api.Assertions.assertThatThrownBy;

import org.junit.jupiter.api.Test;

import j2yb.dam.StorageItem.File;

public class FolderTest {
    @Test
    void testNewFolder() {
        // Arrange
        Folder folder = new Folder("folder", null);

        // Act & Assert
        assertThat(folder.getName()).isEqualTo("folder");
    }

    @Test
    void testAddItem_WhenAddFile_ThenSucess() {
        // Arrange
        Folder folder = new Folder("folder", null);
        File file = new File("file", null, null);

        // Act
        folder.addItem(file);

        // Assert
        assertThat(folder.getItems()).contains(file);
    }

    @Test
    void testAddItem_WhenAddDrive_ThenThrowIllegalArgumentException() {
        // Arrange
        Folder folder = new Folder("folder", null);
        Drive drive = new Drive("drive", null);

        // Act & Assert
        assertThatThrownBy(() -> folder.addItem(drive))
            .isInstanceOf(IllegalArgumentException.class)
            .hasMessage("Drives cannot be added to a folder");
    }

    @Test
    void testAddItem_WhenAddFolder_ThenSucess() {
        // Arrange
        Folder folder = new Folder("folder", null);
        Folder subFolder = new Folder("subFolder", null);

        // Act
        folder.addItem(subFolder);

        // Assert
        assertThat(folder.getItems()).contains(subFolder);
    }

    @Test
    void testGetItems() {
        // Arrange
        Folder folder = new Folder("folder", null);
        File file = new File("file", null, null);
        Folder subFolder = new Folder("subFolder", null);
        folder.addItem(file);
        folder.addItem(subFolder);

        // Act & Assert
        assertThat(folder.getItems()).contains(file);
        assertThat(folder.getItems()).contains(subFolder);
        assertThat(folder.getItems()).hasSize(2);
    }

    @Test
    void testRename() {
        // Arrange
        Folder folder = new Folder("folder", null);

        // Act
        folder.rename("newFolder");

        // Assert
        assertThat(folder.getName()).isEqualTo("newFolder");
    }

    @Test
    void testRename_WhenNewNameIsNull_ThenThrowIllegalArgumentException() {
        // Arrange
        Folder folder = new Folder("folder", null);

        // Act & Assert
        assertThatThrownBy(() -> folder.rename(null))
            .isInstanceOf(IllegalArgumentException.class)
            .hasMessage("Name cannot be null or empty");
    }

    @Test
    void testRename_WhenNewNameIsEmpty_ThenThrowIllegalArgumentException() {
        // Arrange
        Folder folder = new Folder("folder", null);

        // Act & Assert
        assertThatThrownBy(() -> folder.rename(""))
            .isInstanceOf(IllegalArgumentException.class)
            .hasMessage("Name cannot be null or empty");
    }

    @Test
    void testRename_WhenNewNameIsBlank_ThenThrowIllegalArgumentException() {
        // Arrange
        Folder folder = new Folder("folder", null);

        // Act & Assert
        assertThatThrownBy(() -> folder.rename(" "))
            .isInstanceOf(IllegalArgumentException.class)
            .hasMessage("Name cannot be null or empty");
    }

    @Test
    void testDeleteItem() {
        // Arrange
        Folder folder = new Folder("folder", null);
        File file = new File("file", null, null);
        folder.addItem(file);

        // Act
        folder.deleteItemWithName(file.getName());

        // Assert
        assertThat(folder.getItems()).doesNotContain(file);
    }
}
