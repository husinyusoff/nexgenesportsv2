package my.nexgenesports.model;

public class User {
    private String  userID;
    private String  name;
    private String  passwordHash;
    private String  phoneNumber;
    private int     rpId;
    private String  clubSessionID;
    private Integer gamingPassID;  // nullable

    // **NEW**: position field
    private String  position;

    // --- Getters & Setters ---
    public String getUserID()                { return userID; }
    public void   setUserID(String userID)   { this.userID = userID; }

    public String getName()                  { return name; }
    public void   setName(String name)       { this.name = name; }

    public String getPasswordHash()          { return passwordHash; }
    public void   setPasswordHash(String ph) { this.passwordHash = ph; }

    public String getPhoneNumber()           { return phoneNumber; }
    public void   setPhoneNumber(String pn)  { this.phoneNumber = pn; }

    public int    getRpId()                  { return rpId; }
    public void   setRpId(int rpId)          { this.rpId = rpId; }

    public String getClubSessionID()         { return clubSessionID; }
    public void   setClubSessionID(String cs){ this.clubSessionID = cs; }

    public Integer getGamingPassID()         { return gamingPassID; }
    public void    setGamingPassID(Integer g){ this.gamingPassID = g; }

    // **NEW** getter/setter for position
    public String getPosition()              { return position; }
    public void   setPosition(String pos)    { this.position = pos; }
}
