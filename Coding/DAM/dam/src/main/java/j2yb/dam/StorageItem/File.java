package j2yb.dam.StorageItem;

import j2yb.dam.User.User;
import lombok.Getter;

@Getter
public class File extends StorageItem {
    private String content;

    public File(String name, String content, User owner) {
        super(name, owner);
        this.content = content;
    }

    public void changeContent(String string) {
       this.content = string;
    }
    
}
