package j2yb.dam.StorageItem;

import static org.assertj.core.api.Assertions.assertThat;
import static org.assertj.core.api.Assertions.assertThatThrownBy;

import org.junit.jupiter.api.Test;

import j2yb.dam.StorageItem.ContainerItem.Folder;

public class FileTest {
    @Test
    public void testNewFile() {
        File file = new File("file.txt", "content", null);
        assertThat(file.getName()).isEqualTo("file.txt");
        assertThat(file.getContent()).isEqualTo("content");
    }

    @Test
    public void testRename() {
        File file = new File("file.txt", "content", null);
        file.rename("newFile.txt");
        assertThat(file.getName()).isEqualTo("newFile.txt");
    }

    @Test
    public void testChangeContent() {
        File file = new File("file.txt", "content", null);
        file.changeContent("newContent");
        assertThat(file.getContent()).isEqualTo("newContent");
    }

    @Test
    public void testDeleteSelf_whenIsSubFile_ThenSuccess() {
        File file = new File("file.txt", "content", null);
        Folder folder = new Folder("folder", null);
        folder.addItem(file);
        file.deleteSelf();
        assertThat(folder.getItems()).isEmpty();
        assertThat(file.isDeleted()).isTrue();
    }

    @Test
    public void testViewContent_thenReturnFileContent(){
        File file = new File("file.txt", "content", null);
        String expected = "Name: file.txt\nContent: content";
        assertThat(file.viewContent()).isEqualTo(expected);
    }

    @Test
    public void testDeleteSelf_whenFileNotDeleted_thenDeleteSuccess(){
        File file = new File("file.txt", "content", null);
        file.deleteSelf();
        assertThat(file.isDeleted()).isTrue();
    }

    @Test
    public void testDeleteSelf_whenFileDeleted_thenThrowIllegalArgumentException(){
        File file = new File("file.txt", "content", null);
        file.deleteSelf();
        assertThatThrownBy(() -> file.deleteSelf())
            .isInstanceOf(IllegalArgumentException.class)
            .hasMessage("Item is already deleted");
    }
}
