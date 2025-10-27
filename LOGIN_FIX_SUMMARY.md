# ✅ Fixed - Login for Admin & Leader

## 🔴 Vấn đề phát hiện:

### LoginServlet & RegisterServlet thiếu set session attributes

**TRƯỚC (Sai):**
```java
// LoginServlet.java - Line 32
session.setAttribute("account", user);
// ❌ Thiếu: userId, roleId, fullName, email
```

**Kết quả:**
- ViewClubDetailServlet get `roleId` từ session → `null`
- Gây ra **NullPointerException**
- Admin/Leader không được nhận diện → hiển thị như Guest

## ✅ Đã sửa:

### 1. LoginServlet.java

**Thêm đầy đủ session attributes:**
```java
if (user != null && BCrypt.checkpw(passwordHash, user.getPasswordHash())) {
    HttpSession session = request.getSession();
    
    // Set user information in session
    session.setAttribute("account", user);
    session.setAttribute("userId", user.getUserId());       // ✅ NEW
    session.setAttribute("roleId", user.getRoleId());       // ✅ NEW - CRITICAL!
    session.setAttribute("fullName", user.getFullName());   // ✅ NEW
    session.setAttribute("email", user.getEmail());         // ✅ NEW
    
    // Handle redirect from guest
    String redirect = request.getParameter("redirect");
    String clubId = request.getParameter("clubId");
    String eventId = request.getParameter("eventId");
    
    if ("clubDetail".equals(redirect) && clubId != null) {
        String redirectUrl = "clubDetail?clubId=" + clubId;
        if (eventId != null) {
            redirectUrl += "&eventId=" + eventId;
        }
        response.sendRedirect(redirectUrl);
    } else {
        response.sendRedirect("home");
    }
}
```

**Features added:**
- ✅ Set `roleId` → ViewClubDetailServlet can check role
- ✅ Set `userId` → Can check if user is club leader
- ✅ Set `fullName`, `email` → For display
- ✅ **Redirect support** → Guest login → back to club detail

### 2. RegisterServlet.java

**Thêm đầy đủ session attributes:**
```java
if (success) {
    HttpSession session = request.getSession();
    
    // Set user information in session
    session.setAttribute("account", newUser);
    session.setAttribute("userId", newUser.getUserId());      // ✅ NEW
    session.setAttribute("roleId", newUser.getRoleId());      // ✅ NEW
    session.setAttribute("fullName", newUser.getFullName());  // ✅ NEW
    session.setAttribute("email", newUser.getEmail());        // ✅ NEW
    
    response.sendRedirect("home");
}
```

## 📊 Session Attributes - Complete List

| Attribute | Type | Source | Usage |
|-----------|------|--------|-------|
| `account` | `User` | `user` object | Legacy, full user object |
| `userId` | `Integer` | `user.getUserId()` | Identify user, check club membership |
| `roleId` | `Integer` | `user.getRoleId()` | **Critical!** Determine permissions |
| `fullName` | `String` | `user.getFullName()` | Display in header, profile |
| `email` | `String` | `user.getEmail()` | Display, verification |

## 🔐 Role Checking Flow

### After Login:
```
1. User enters email/password
2. LoginServlet validates credentials
3. If valid:
   - Create session
   - Set account, userId, roleId, fullName, email
   - Redirect to home (or back to clubDetail if guest)

4. ViewClubDetailServlet receives request:
   - Get session
   - Get roleId from session
   - Check:
     * roleId == 1 → Admin → isLeaderOrAdmin = true
     * roleId == 2 → Club Leader → isLeaderOrAdmin = true
     * roleId == 3 → Member → Check if leader of this club
     * roleId == 4 or null → Regular User → isLeaderOrAdmin = false
   - Forward to JSP with isLeaderOrAdmin attribute
```

## 🎯 RoleID Values (Expected in Database)

| RoleID | RoleName | Description | Permissions in Club Detail |
|--------|----------|-------------|----------------------------|
| `1` | Admin | System Administrator | Full access: Edit, Delete, Dashboard, Members list |
| `2` | Club Leader | Leader of any club | Full access: Edit, Delete, Dashboard, Members list |
| `3` | Member | Club member | If leader of THIS club → Full access<br>Else → Public view |
| `4` | User | Regular user | Public view: Events, Info, Reviews |

## 🗄️ Database Check & Setup

### Run SQL Script:

**File:** `CHECK_ROLES.sql`

**What it does:**
1. ✅ Check if Roles table has Admin, Club Leader roles
2. ✅ Create roles if missing
3. ✅ Check if Admin user exists
4. ✅ Create default Admin account if missing:
   - Email: `admin@clubmanagement.com`
   - Password: `admin123`
5. ✅ Create default Club Leader account if missing:
   - Email: `leader@clubmanagement.com`
   - Password: `leader123`

**How to run:**
```sql
-- In SSMS or Azure Data Studio
-- Open CHECK_ROLES.sql
-- Execute (F5)
```

**Expected output:**
```
=== ROLES TABLE ===
RoleID  RoleName      Description
1       Admin         System Administrator
2       Club Leader   Leader of a club
3       Member        Club member
4       User          Regular user

✅ Admin user created: admin@clubmanagement.com / admin123
✅ Club Leader user created: leader@clubmanagement.com / leader123
```

## 🧪 Test Cases

### Test 1: Login as Admin
```
1. Go to: /login
2. Enter:
   Email: admin@clubmanagement.com
   Password: admin123
3. Click Login
4. Check session (in browser DevTools → Application → Session Storage):
   ✅ account = User object
   ✅ userId = 1 (or admin's userId)
   ✅ roleId = 1
   ✅ fullName = "System Administrator"
5. Go to: /clubDetail?clubId=1
6. Expected:
   ✅ Sees Edit/Delete/Dashboard buttons
   ✅ Sees Members tab
   ✅ Sees Events tab
   ❌ Does NOT see "Tham gia CLB" button
```

### Test 2: Login as Club Leader
```
1. Go to: /login
2. Enter:
   Email: leader@clubmanagement.com
   Password: leader123
3. Click Login
4. Check session:
   ✅ roleId = 2
5. Go to: /clubDetail?clubId=1
6. Expected:
   ✅ Sees Edit/Delete/Dashboard buttons (same as Admin)
```

### Test 3: Login as Regular User
```
1. Register new account (roleId will be 4 by default)
2. Login
3. Check session:
   ✅ roleId = 4
4. Go to: /clubDetail?clubId=1
5. Expected:
   ❌ Does NOT see Edit/Delete buttons
   ✅ Sees public view (Events, Info, Reviews)
   ✅ Sees "Tham gia CLB" button
```

### Test 4: Guest → Login → Redirect back
```
1. Open browser (no login)
2. Go to: /clubDetail?clubId=1
3. Click "Tham gia CLB"
4. Prompt: "Bạn cần đăng nhập..."
5. Click OK → Redirect to: /login?redirect=clubDetail&clubId=1
6. Enter credentials and login
7. Expected:
   ✅ After login, redirect back to /clubDetail?clubId=1
   ✅ Now logged in, can join club
```

## 🔧 Default Passwords

**⚠️ IMPORTANT:** Change these passwords after first login!

### Admin Account:
```
Email: admin@clubmanagement.com
Password: admin123
```

### Club Leader Account:
```
Email: leader@clubmanagement.com
Password: leader123
```

## 📝 Files Modified:

1. ✅ `src/java/controller/LoginServlet.java`
   - Added session attributes: userId, roleId, fullName, email
   - Added redirect support for guest users

2. ✅ `src/java/controller/RegisterServlet.java`
   - Added session attributes: userId, roleId, fullName, email

3. ✅ `CHECK_ROLES.sql` (NEW)
   - SQL script to check/create roles and default accounts

## 🚀 Deployment Steps:

### 1. Run SQL Script
```sql
-- In SSMS, open and execute:
CHECK_ROLES.sql
```

### 2. Clean and Build
```
NetBeans → Right-click project → Clean and Build
```

### 3. Redeploy
```
NetBeans → Right-click project → Run
```

### 4. Test Login
```
1. Go to: http://localhost:8080/SWP391-ClubsManagement/login
2. Login as Admin: admin@clubmanagement.com / admin123
3. Go to: http://localhost:8080/SWP391-ClubsManagement/clubDetail?clubId=1
4. Verify you see Edit/Delete/Dashboard buttons
```

---

**Status:** ✅ Complete  
**Critical Fix:** Added `roleId` to session  
**Bonus:** Added redirect support for guest users  
**Next:** Test with Admin and Leader accounts

