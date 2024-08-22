package j2yb.dam.StorageItem;

import static org.assertj.core.api.Assertions.assertThat;

import org.junit.jupiter.api.Test;

public class FileTest {
    @Test
    public void testNewFile() {
        File file = new File("file.txt", "content", null);
        assertThat(file.getName()).isEqualTo("file.txt");
        assertThat(file.getContent()).isEqualTo("content");
    }
}
