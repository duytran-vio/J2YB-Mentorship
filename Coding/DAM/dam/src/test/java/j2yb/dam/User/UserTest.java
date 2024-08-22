package j2yb.dam.User;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;

import j2yb.dam.Permission.Permission;
import j2yb.dam.Permission.Role;
import j2yb.dam.StorageItem.ContainerItem.Drive;

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
}
