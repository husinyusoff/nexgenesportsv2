// File: src/main/java/my/nexgenesports/model/MeritLevel.java
package my.nexgenesports.model;

public class MeritLevel {

    private int meritId;
    private String name;
    private String description;
    private String category;  // new
    private String scope;     // new

    public int getMeritId() {
        return meritId;
    }

    public void setMeritId(int meritId) {
        this.meritId = meritId;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public String getCategory() {
        return category;
    }

    public void setCategory(String category) {
        this.category = category;
    }

    public String getScope() {
        return scope;
    }

    public void setScope(String scope) {
        this.scope = scope;
    }
}
