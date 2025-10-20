package model;

import java.sql.Timestamp;

/**
 * User model class representing the Users table in the database Database
 * structure: UserID, FullName, Email, PasswordHash, PhoneNumber, Address,
 * Gender, RoleID, ProfileImage, CreatedAt
 */
public class User {

    private int userId;
    private String fullName;
    private String email;
    private String passwordHash;
    private String phoneNumber;
    private String address;
    private String gender;
    private int roleId; // Foreign key to Roles.RoleID
    private String profileImage;
    private Timestamp createdAt;

    public User() {
    }

    // Constructor đầy đủ
    public User(int userId, String fullName, String email, String passwordHash,
            String phoneNumber, String address, String gender, int roleId,
            String profileImage, Timestamp createdAt) {
        this.userId = userId;
        this.fullName = fullName;
        this.email = email;
        this.passwordHash = passwordHash;
        this.phoneNumber = phoneNumber;
        this.address = address;
        this.gender = gender;
        this.roleId = roleId;
        this.profileImage = profileImage;
        this.createdAt = createdAt;
    }

    // Constructor không có ID (cho insert)
    public User(String fullName, String email, String passwordHash,
            String phoneNumber, String address, String gender, int roleId,
            String profileImage) {
        this.fullName = fullName;
        this.email = email;
        this.passwordHash = passwordHash;
        this.phoneNumber = phoneNumber;
        this.address = address;
        this.gender = gender;
        this.roleId = roleId;
        this.profileImage = profileImage;
        this.createdAt = new Timestamp(System.currentTimeMillis());
    }

    public User(int userId, String fullName, String email, String passwordHash, int roleId) {
        this.userId = userId;
        this.fullName = fullName;
        this.email = email;
        this.passwordHash = passwordHash;
        this.roleId = roleId;
    }

    // Getters & Setters
    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

    public String getFullName() {
        return fullName;
    }

    public void setFullName(String fullName) {
        this.fullName = fullName;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getPasswordHash() {
        return passwordHash;
    }

    public void setPasswordHash(String passwordHash) {
        this.passwordHash = passwordHash;
    }

    public String getPhoneNumber() {
        return phoneNumber;
    }

    public void setPhoneNumber(String phoneNumber) {
        this.phoneNumber = phoneNumber;
    }

    public String getAddress() {
        return address;
    }

    public void setAddress(String address) {
        this.address = address;
    }

    public String getGender() {
        return gender;
    }

    public void setGender(String gender) {
        this.gender = gender;
    }

    public int getRoleId() {
        return roleId;
    }

    public void setRoleId(int roleId) {
        this.roleId = roleId;
    }

    public String getProfileImage() {
        return profileImage;
    }

    public void setProfileImage(String profileImage) {
        this.profileImage = profileImage;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }

    // Utility methods
    /**
     * Get default profile image if profileImage is null or empty
     *
     * @return profile image URL or default placeholder
     */
    public String getProfileImageOrDefault() {
        if (this.profileImage == null || this.profileImage.trim().isEmpty()) {
            return "assets/images/users/default-avatar.png";
        }
        return this.profileImage;
    }

    /**
     * Get formatted creation date
     *
     * @return formatted date string
     */
    public String getFormattedCreatedAt() {
        if (this.createdAt == null) {
            return "Unknown";
        }

        try {
            java.text.SimpleDateFormat sdf = new java.text.SimpleDateFormat("MMM dd, yyyy");
            return sdf.format(this.createdAt);
        } catch (Exception e) {
            return "Unknown";
        }
    }

    /**
     * Get display name (first name from full name)
     *
     * @return first name or full name if no space found
     */
    public String getDisplayName() {
        if (this.fullName == null || this.fullName.trim().isEmpty()) {
            return "Unknown User";
        }

        String[] names = this.fullName.trim().split("\\s+");
        return names[0];
    }

    /**
     * Get initials from full name
     *
     * @return initials string
     */
    public String getInitials() {
        if (this.fullName == null || this.fullName.trim().isEmpty()) {
            return "U";
        }

        String[] names = this.fullName.trim().split("\\s+");
        StringBuilder initials = new StringBuilder();

        for (String name : names) {
            if (!name.isEmpty()) {
                initials.append(name.charAt(0));
            }
        }

        return initials.toString().toUpperCase();
    }

    /**
     * Check if user has profile image
     *
     * @return true if profile image exists, false otherwise
     */
    public boolean hasProfileImage() {
        return this.profileImage != null && !this.profileImage.trim().isEmpty();
    }

    /**
     * Get masked email for display (e.g., j***@example.com)
     *
     * @return masked email string
     */
    public String getMaskedEmail() {
        if (this.email == null || this.email.trim().isEmpty()) {
            return "***@***";
        }

        String[] parts = this.email.split("@");
        if (parts.length != 2) {
            return "***@***";
        }

        String username = parts[0];
        String domain = parts[1];

        if (username.length() <= 1) {
            return "*@" + domain;
        }

        return username.charAt(0) + "*".repeat(username.length() - 1) + "@" + domain;
    }

    /**
     * Get masked phone number for display (e.g., 091***5678)
     *
     * @return masked phone number string
     */
    public String getMaskedPhoneNumber() {
        if (this.phoneNumber == null || this.phoneNumber.trim().isEmpty()) {
            return "***";
        }

        String phone = this.phoneNumber.trim();
        if (phone.length() <= 4) {
            return "*".repeat(phone.length());
        }

        return phone.substring(0, 3) + "*".repeat(phone.length() - 6) + phone.substring(phone.length() - 3);
    }

    @Override
    public String toString() {
        return "User{"
                + "userId=" + userId
                + ", fullName='" + fullName + '\''
                + ", email='" + email + '\''
                + ", phoneNumber='" + phoneNumber + '\''
                + ", address='" + address + '\''
                + ", gender='" + gender + '\''
                + ", roleId=" + roleId
                + ", profileImage='" + profileImage + '\''
                + ", createdAt=" + createdAt
                + '}';
    }

    @Override
    public boolean equals(Object obj) {
        if (this == obj) {
            return true;
        }
        if (obj == null || getClass() != obj.getClass()) {
            return false;
        }

        User user = (User) obj;
        return userId == user.userId;
    }

    @Override
    public int hashCode() {
        return Integer.hashCode(userId);
    }
}
