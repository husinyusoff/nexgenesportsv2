// src/main/java/my/nexgenesports/service/booking/BusinessConfigService.java
package my.nexgenesports.service.booking;

import my.nexgenesports.dao.booking.BusinessConfigDao;
import my.nexgenesports.dao.booking.BusinessConfigDaoImpl;
import my.nexgenesports.service.general.ServiceException;

import java.sql.SQLException;
import java.time.DayOfWeek;
import java.util.Map;

public final class BusinessConfigService {
    private final BusinessConfigDao dao = new BusinessConfigDaoImpl();
    private Map<String,Integer> cache;

    public BusinessConfigService() {
        reload();
    }

    public void reload() {
        try {
            cache = dao.findAll();
        } catch(SQLException e) {
            throw new ServiceException("Config load failed", e);
        }
    }

    public int get(String key) {
        return cache.getOrDefault(key, 0);
    }

    public void set(String key, int value) {
        try {
            dao.update(key, value);
            cache.put(key, value);
        } catch (SQLException e) {
            throw new ServiceException("Config update failed", e);
        }
    }

    public int openingHour(DayOfWeek dow) {
        boolean weekend = dow == DayOfWeek.FRIDAY || dow == DayOfWeek.SATURDAY;
        return get(weekend ? "weekend_open" : "weekday_open");
    }

    public int closingHour() {
        return get("closing_hour");
    }

    public int happyStart(DayOfWeek dow) {
        return openingHour(dow) + get("happy_start_offset");
    }

    public int happyEnd() {
        return get("happy_end_hour");
    }
}
