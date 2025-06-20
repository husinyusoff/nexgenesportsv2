package my.nexgenesports.util;

import java.util.List;

public class RoleUtils {
    public static boolean isAllowedRole(List<String> effectiveRoles, String permRole) {
        return effectiveRoles != null && effectiveRoles.contains(permRole);
    }
}
