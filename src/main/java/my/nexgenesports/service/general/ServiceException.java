package my.nexgenesports.service.general;

/**
 * A runtime exception to signal business-rule or validation failures.
 */
public class ServiceException extends RuntimeException {
    public ServiceException(String message) {
        super(message);
    }
    public ServiceException(String message, Throwable cause) {
        super(message, cause);
    }
}
