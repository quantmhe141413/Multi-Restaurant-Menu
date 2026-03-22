package constants;

public class UserRole {
    public static final int SUPER_ADMIN = 1;
    public static final int OWNER = 2;
    public static final int STAFF = 3;
    public static final int CUSTOMER = 4;
    
    public static final String SUPER_ADMIN_NAME = "SuperAdmin";
    public static final String OWNER_NAME = "Owner";
    public static final String STAFF_NAME = "Staff";
    public static final String CUSTOMER_NAME = "Customer";
    
    // Prevent instantiation
    private UserRole() {
    }
    
    public static String getRoleName(int roleId) {
        switch (roleId) {
            case SUPER_ADMIN:
                return SUPER_ADMIN_NAME;
            case OWNER:
                return OWNER_NAME;
            case STAFF:
                return STAFF_NAME;
            case CUSTOMER:
                return CUSTOMER_NAME;
            default:
                return "Unknown";
        }
    }
    
    public static boolean isSuperAdmin(int roleId) {
        return roleId == SUPER_ADMIN;
    }
    
    public static boolean isOwner(int roleId) {
        return roleId == OWNER;
    }
    
    public static boolean isStaff(int roleId) {
        return roleId == STAFF;
    }
    
    public static boolean isCustomer(int roleId) {
        return roleId == CUSTOMER;
    }
}
