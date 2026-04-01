import org.mindrot.jbcrypt.BCrypt;

public class GenHash {
    public static void main(String[] args) {
        String hashed = BCrypt.hashpw("password123", BCrypt.gensalt(10));
        System.out.println("HASH=" + hashed);
    }
}
