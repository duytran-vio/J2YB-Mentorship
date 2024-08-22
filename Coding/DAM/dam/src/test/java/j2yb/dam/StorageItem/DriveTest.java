package j2yb.dam.StorageItem;

import static org.assertj.core.api.Assertions.assertThat;

import org.junit.jupiter.api.Test;

import j2yb.dam.StorageItem.ContainerItem.Drive;

public class DriveTest {
    @Test
    public void testNewDrive() {
        Drive drive = new Drive("C:", null);
        assertThat(drive.getName()).isEqualTo("C:");
    }
}
