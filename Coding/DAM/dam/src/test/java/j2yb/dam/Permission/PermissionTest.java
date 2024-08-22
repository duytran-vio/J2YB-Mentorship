package j2yb.dam.Permission;

import static org.assertj.core.api.Assertions.assertThat;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;

import j2yb.dam.StorageItem.ContainerItem.Drive;
import j2yb.dam.User.User;

public class PermissionTest {

    @BeforeEach
    void setUp() {
        Permission.clear();
    }

    @Test
    void testAddPermission() {
        User user = new User("John Doe");
        Drive drive = user.createDrive("DriveA");
        String key = user.getId().toString() + '/' + drive.getId().toString();
        Permission.addPermission(user, drive, Role.ADMIN);
        assertThat(Permission.permissions.size()).isEqualTo(1);
        assertThat(Permission.permissions.containsKey(key)).isNotNull();
        assertThat(Permission.permissions.get(key)).isEqualTo(Role.ADMIN);
    }

    @Test
    void testGetPermission() {
        User user = new User("John Doe");
        Drive drive = user.createDrive("DriveA");
        Permission.addPermission(user, drive, Role.ADMIN);
        Role permission = Permission.getRole(user, drive);
        assertThat(permission).isEqualTo(Role.ADMIN);
    }

    @Test
    void testGetPermissionKey() {
        User user = new User("John Doe");
        Drive drive = user.createDrive("DriveA");
        String expectedKey = user.getId().toString() + '/' + drive.getId().toString();
        String key = Permission.getPermissionKey(user, drive);
        assertThat(key).isEqualTo(expectedKey);
    }
}
