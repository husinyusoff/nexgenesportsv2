// src/main/java/my/nexgenesports/model/Page.java
package my.nexgenesports.model;

public class Page {
    private int    pageId;
    private String url;
    private String name;
    private boolean inheritPermission;

    // getters & setters
    public int getPageId() { return pageId; }
    public void setPageId(int pageId) { this.pageId = pageId; }
    public String getUrl() { return url; }
    public void setUrl(String url) { this.url = url; }
    public String getName() { return name; }
    public void setName(String name) { this.name = name; }
    public boolean isInheritPermission() { return inheritPermission; }
    public void setInheritPermission(boolean inheritPermission) {
      this.inheritPermission = inheritPermission;
    }
}
