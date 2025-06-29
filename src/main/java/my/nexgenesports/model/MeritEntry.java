package my.nexgenesports.model;

public class MeritEntry {
    private int    meritId;
    private String category;  // "Program" or "Tournament"
    private String scope;     // "Club","University","State","National","International"
    private int    points;    // the one score we display

    // getters & setters
    public int getMeritId()               { return meritId; }
    public void setMeritId(int m)         { this.meritId = m; }
    public String getCategory()           { return category; }
    public void setCategory(String c)     { this.category = c; }
    public String getScope()              { return scope; }
    public void setScope(String s)        { this.scope = s; }
    public int getPoints()                { return points; }
    public void setPoints(int p)          { this.points = p; }
}
