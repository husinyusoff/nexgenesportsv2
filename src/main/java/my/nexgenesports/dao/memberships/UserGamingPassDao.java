// src/main/java/my/nexgenesports/dao/UserGamingPassDao.java
package my.nexgenesports.dao.memberships;

import my.nexgenesports.model.UserGamingPass;
import java.sql.SQLException;

public interface UserGamingPassDao {
    void insert(UserGamingPass p) throws SQLException;
    UserGamingPass findLatestByUser(String userId) throws SQLException;

    /** NEW: fetch by primary key
     * @param id
     * @return 
     * @throws java.sql.SQLException */
    UserGamingPass findById(int id) throws SQLException;

    /** NEW: update expiryDate (and paymentReference if you add one)
     * @param p
     * @throws java.sql.SQLException */
    void update(UserGamingPass p) throws SQLException;
}
