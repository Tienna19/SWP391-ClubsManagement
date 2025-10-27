package model;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

/**
 * Data Transfer Object for displaying member information
 * Used when we need to JOIN Memberships with Users table
 * Contains display-ready data (fullName, profileImage)
 */
public class MemberDTO {
    private int userId;
    private String fullName;
    private String roleInClub;
    private String profileImage;
    private LocalDateTime joinDate;

    public MemberDTO(int userId, String fullName, String roleInClub,
                     String profileImage, LocalDateTime joinDate) {
        this.userId = userId;
        this.fullName = fullName;
        this.roleInClub = roleInClub;
        this.profileImage = profileImage;
        this.joinDate = joinDate;
    }

    public int getUserId() { return userId; }
    public String getFullName() { return fullName; }
    public String getRoleInClub() { return roleInClub; }
    public String getProfileImage() { return profileImage; }
    public LocalDateTime getJoinDate() { return joinDate; }

  
    public String getJoinDateDisplay() {
        if (joinDate == null) return "";
        return joinDate.format(DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm"));
    }
}
