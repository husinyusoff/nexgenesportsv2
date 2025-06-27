// File: src/main/java/my/nexgenesports/dao/booking/BusinessConfigDao.java
package my.nexgenesports.dao.booking;

import java.sql.SQLException;
import java.util.Map;

public interface BusinessConfigDao {
    /**
     * Load all config keys and values.
     * @return 
     * @throws java.sql.SQLException
     */
    Map<String,Integer> findAll() throws SQLException;

    /**
     * Update a single config value.
     * @param key
     * @param value
     * @throws java.sql.SQLException
     */
    void update(String key, int value) throws SQLException;

    /**
     * Read one integer config, returning defaultValue if not present.
     * @param key
     * @param defaultValue
     * @return 
     * @throws java.sql.SQLException
     */
    int getInt(String key, int defaultValue) throws SQLException;
}
