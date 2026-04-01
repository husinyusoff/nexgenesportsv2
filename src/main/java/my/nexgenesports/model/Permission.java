// src/main/java/my/nexgenesports/model/Permission.java
package my.nexgenesports.model;

public class Permission {
    private int pageId;
    private int rpId;
    private boolean granted;

    public int getPageId() { return pageId; }
    public void setPageId(int pageId) { this.pageId = pageId; }

    public int getRpId() { return rpId; }
    public void setRpId(int rpId) { this.rpId = rpId; }

    public boolean isGranted() { return granted; }
    public void setGranted(boolean granted) { this.granted = granted; }
}
