package my.nexgenesports.model;

import java.time.LocalDateTime;

public class User {
    private String  userID;
    private String  name;
    private String  email;
    private String  passwordHash;
    private String  phoneNumber;
    private String  matricNumber;
    private String  ign;           // In-Game Name (single default; per-game IGNs deferred to Team module)
    private String  bio;
    private String  discordID;
    private LocalDateTime registrationDate;
    private String  passwordResetToken;
    private LocalDateTime passwordResetExpiry;
    private int     rpId;

    // position comes from JOIN with role_positions
    private String  position;

    // --- Getters & Setters ---
    public String getUserID()                          { return userID; }
    public void   setUserID(String userID)             { this.userID = userID; }

    public String getName()                            { return name; }
    public void   setName(String name)                 { this.name = name; }

    public String getEmail()                           { return email; }
    public void   setEmail(String email)               { this.email = email; }

    public String getPasswordHash()                    { return passwordHash; }
    public void   setPasswordHash(String ph)           { this.passwordHash = ph; }

    public String getPhoneNumber()                     { return phoneNumber; }
    public void   setPhoneNumber(String pn)            { this.phoneNumber = pn; }

    public String getMatricNumber()                    { return matricNumber; }
    public void   setMatricNumber(String mn)           { this.matricNumber = mn; }

    public String getIgn()                             { return ign; }
    public void   setIgn(String ign)                   { this.ign = ign; }

    public String getBio()                             { return bio; }
    public void   setBio(String bio)                   { this.bio = bio; }

    public String getDiscordID()                       { return discordID; }
    public void   setDiscordID(String discordID)       { this.discordID = discordID; }

    public LocalDateTime getRegistrationDate()         { return registrationDate; }
    public void   setRegistrationDate(LocalDateTime d) { this.registrationDate = d; }

    public String getFormattedRegistrationDate() {
        if (registrationDate == null) return "N/A";
        return registrationDate.format(java.time.format.DateTimeFormatter.ofPattern("HH:mm dd/MM/yyyy"));
    }

    public String getPasswordResetToken()              { return passwordResetToken; }
    public void   setPasswordResetToken(String t)      { this.passwordResetToken = t; }

    public LocalDateTime getPasswordResetExpiry()      { return passwordResetExpiry; }
    public void   setPasswordResetExpiry(LocalDateTime e) { this.passwordResetExpiry = e; }

    public int    getRpId()                            { return rpId; }
    public void   setRpId(int rpId)                    { this.rpId = rpId; }

    public String getPosition()                        { return position; }
    public void   setPosition(String pos)              { this.position = pos; }
}
