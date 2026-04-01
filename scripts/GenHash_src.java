import org.mindrot.jbcrypt.BCrypt;

public class GenHash {
    public static void main(String[] args) {
        String existingHash = "$2a$10$pxVj02PtGQTd1Q25Av2anOogSfcr1c3Zr2d0LJT1hlemTdHMkEw8.";
        String[] tests = {"password", "password123", "admin", "123456", "1234", "12345678"};
        
        for (String test : tests) {
            if (BCrypt.checkpw(test, existingHash)) {
                System.out.println("THE PASSWORD IS: " + test);
                return;
            }
        }
        
        System.out.println("NEW HASH FOR 'password123': " + BCrypt.hashpw("password123", BCrypt.gensalt(10)));
    }
}
