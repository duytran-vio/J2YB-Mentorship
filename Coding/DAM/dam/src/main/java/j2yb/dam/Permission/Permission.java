package j2yb.dam.Permission;

import java.util.HashMap;
import java.util.Map;

import j2yb.dam.StorageItem.StorageItem;
import j2yb.dam.User.User;
import lombok.Getter;

@Getter
public final class Permission {
    public static Map<String, Role> permissions = new HashMap<>();

    public static void addPermission(User user, StorageItem item, Role role) {
        String key = getPermissionKey(user, item);
        permissions.put(key, role);
    }

    public static Role getRole(User user, StorageItem item) {
        String key = getPermissionKey(user, item);
        return permissions.get(key);
    }

    public static String getPermissionKey(User user, StorageItem item) {
        return user.getId().toString() + '/' + item.getId().toString();
    }

    public static void clear() {
        permissions.clear();
    }
}
