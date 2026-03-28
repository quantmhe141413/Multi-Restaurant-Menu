package utils;

import java.util.Properties;
import javax.mail.Authenticator;
import javax.mail.Message;
import javax.mail.MessagingException;
import javax.mail.PasswordAuthentication;
import javax.mail.Session;
import javax.mail.Transport;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeMessage;
import javax.mail.internet.MimeUtility;

public class EmailService {

    private static final String FROM_EMAIL = "quantm160@gmail.com";
    private static final String APP_PASSWORD = "uzfi bnwd ctie pyvk";
    private static final String SMTP_HOST = "smtp.gmail.com";
    private static final String SMTP_PORT = "587";

    /**
     * Send password reset email to user
     * 
     * @param toEmail   Recipient email address
     * @param resetLink Password reset link
     * @return true if email sent successfully, false otherwise
     */
    public static boolean sendPasswordResetEmail(String toEmail, String resetLink) {
        try {
            // Setup mail server properties
            Properties props = new Properties();
            props.put("mail.smtp.auth", "true");
            props.put("mail.smtp.starttls.enable", "true");
            props.put("mail.smtp.host", SMTP_HOST);
            props.put("mail.smtp.port", SMTP_PORT);
            props.put("mail.smtp.ssl.protocols", "TLSv1.2");
            props.put("mail.mime.charset", "UTF-8");

            // Create authenticator
            Authenticator auth = new Authenticator() {
                @Override
                protected PasswordAuthentication getPasswordAuthentication() {
                    return new PasswordAuthentication(FROM_EMAIL, APP_PASSWORD);
                }
            };

            // Create session
            Session session = Session.getInstance(props, auth);
            session.setDebug(false); // Set to true for detailed SMTP logs

            // Create message
            MimeMessage message = new MimeMessage(session);
            message.setFrom(new InternetAddress(FROM_EMAIL, "Multi-Restaurant Menu", "UTF-8"));
            message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(toEmail));
            message.setSubject("Reset Your Password - Multi-Restaurant Menu", "UTF-8");

            // HTML email content
            String htmlContent = buildEmailContent(resetLink);
            message.setContent(htmlContent, "text/html; charset=utf-8");
            message.saveChanges();

            // Send email
            Transport.send(message);

            return true;

        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Build HTML email content
     */
    private static String buildEmailContent(String resetLink) {
        return "<!DOCTYPE html>" +
                "<html lang='en'>" +
                "<head>" +
                "    <meta charset='UTF-8'>" +
                "    <meta name='viewport' content='width=device-width, initial-scale=1.0'>" +
                "    <title>Reset Your Password</title>" +
                "</head>" +
                "<body style='margin: 0; padding: 0; font-family: Arial, sans-serif; background-color: #f4f4f4;'>" +
                "    <table width='100%' cellpadding='0' cellspacing='0' style='background-color: #f4f4f4; padding: 20px;'>"
                +
                "        <tr>" +
                "            <td align='center'>" +
                "                <table width='600' cellpadding='0' cellspacing='0' style='background-color: #ffffff; border-radius: 10px; overflow: hidden; box-shadow: 0 2px 10px rgba(0,0,0,0.1);'>"
                +
                "                    <!-- Header -->" +
                "                    <tr>" +
                "                        <td style='background: linear-gradient(135deg, #ff4757 0%, #ff6b81 100%); padding: 30px; text-align: center;'>"
                +
                "                            <h1 style='margin: 0; color: #ffffff; font-size: 28px;'>🔐 Password Reset</h1>"
                +
                "                        </td>" +
                "                    </tr>" +
                "                    " +
                "                    <!-- Content -->" +
                "                    <tr>" +
                "                        <td style='padding: 40px 30px;'>" +
                "                            <h2 style='margin-top: 0; color: #2f3542; font-size: 22px;'>Reset Your Password</h2>"
                +
                "                            <p style='color: #57606f; font-size: 16px; line-height: 1.6;'>" +
                "                                We received a request to reset your password for your Multi-Restaurant Menu account."
                +
                "                            </p>" +
                "                            <p style='color: #57606f; font-size: 16px; line-height: 1.6;'>" +
                "                                Click the button below to reset your password. This link will expire in <strong>1 hour</strong>."
                +
                "                            </p>" +
                "                            " +
                "                            <!-- Button -->" +
                "                            <table width='100%' cellpadding='0' cellspacing='0' style='margin: 30px 0;'>"
                +
                "                                <tr>" +
                "                                    <td align='center'>" +
                "                                        <a href='" + resetLink
                + "' style='display: inline-block; padding: 15px 40px; background-color: #ff4757; color: #ffffff; text-decoration: none; border-radius: 8px; font-size: 16px; font-weight: bold;'>Reset Password</a>"
                +
                "                                    </td>" +
                "                                </tr>" +
                "                            </table>" +
                "                            " +
                "                            <p style='color: #57606f; font-size: 14px; line-height: 1.6;'>" +
                "                                Or copy and paste this link into your browser:" +
                "                            </p>" +
                "                            <p style='color: #1976d2; font-size: 14px; word-break: break-all; background-color: #f1f2f6; padding: 12px; border-radius: 6px;'>"
                +
                "                                " + resetLink +
                "                            </p>" +
                "                            " +
                "                            <hr style='border: none; border-top: 1px solid #e0e0e0; margin: 30px 0;'>"
                +
                "                            " +
                "                            <p style='color: #95a5a6; font-size: 13px; line-height: 1.6;'>" +
                "                                <strong>Didn't request this?</strong> You can safely ignore this email. Your password will remain unchanged."
                +
                "                            </p>" +
                "                        </td>" +
                "                    </tr>" +
                "                    " +
                "                    <!-- Footer -->" +
                "                    <tr>" +
                "                        <td style='background-color: #2f3542; padding: 20px; text-align: center;'>" +
                "                            <p style='margin: 0; color: #ffffff; font-size: 14px;'>" +
                "                                © 2026 Multi-Restaurant Menu. All rights reserved." +
                "                            </p>" +
                "                            <p style='margin: 10px 0 0 0; color: #95a5a6; font-size: 12px;'>" +
                "                                This is an automated email. Please do not reply." +
                "                            </p>" +
                "                        </td>" +
                "                    </tr>" +
                "                </table>" +
                "            </td>" +
                "        </tr>" +
                "    </table>" +
                "</body>" +
                "</html>";
    }

    /**
     * Test email sending
     */
    public static void main(String[] args) {
        String testEmail = "test@example.com";
        String testLink = "http://localhost:8080/reset-password?token=test-token-123";

        System.out.println("Testing email service...");
        boolean success = sendPasswordResetEmail(testEmail, testLink);

        if (success) {
            System.out.println("✅ Email sent successfully to: " + testEmail);
        } else {
            System.out.println("❌ Failed to send email");
        }
    }

    // ------------- BẮT ĐẦU CÁC HÀM ADMIN (TỪ MRM-1) -------------
    public static boolean sendRestaurantApprovalEmail(String ownerEmail, String ownerName, String restaurantName) {
        if (ownerEmail == null || ownerEmail.trim().isEmpty() ||
            ownerName == null || ownerName.trim().isEmpty() ||
            restaurantName == null || restaurantName.trim().isEmpty()) {
            return false;
        }
        String subject = "Restaurant Application Approved - " + restaurantName;
        String message = buildApprovalEmail(ownerName, restaurantName);
        return sendEmailCustom(ownerEmail.trim(), subject, message);
    }

    public static boolean sendRestaurantRejectionEmail(String ownerEmail, String ownerName, String restaurantName, String rejectionReason) {
        if (ownerEmail == null || ownerEmail.trim().isEmpty() ||
            ownerName == null || ownerName.trim().isEmpty() ||
            restaurantName == null || restaurantName.trim().isEmpty() ||
            rejectionReason == null || rejectionReason.trim().isEmpty()) {
            return false;
        }
        String subject = "Restaurant Application Rejected - " + restaurantName;
        String message = buildRejectionEmail(ownerName, restaurantName, rejectionReason);
        return sendEmailCustom(ownerEmail.trim(), subject, message);
    }

    public static boolean sendComplaintStatusEmail(String ownerEmail, String ownerName, String restaurantName,
            int complaintId, String status, String adminNote) {
        if (ownerEmail == null || ownerEmail.trim().isEmpty()
                || restaurantName == null || restaurantName.trim().isEmpty()
                || status == null || status.trim().isEmpty()) {
            return false;
        }
        String safeOwnerName = (ownerName == null || ownerName.trim().isEmpty()) ? "Restaurant Owner" : ownerName.trim();
        String safeNote = adminNote == null ? "" : adminNote.trim();
        String subject = "Complaint #" + complaintId + " Status Updated - " + restaurantName;
        String message = buildComplaintStatusEmail(safeOwnerName, restaurantName, complaintId, status.trim(), safeNote);
        return sendEmailCustom(ownerEmail.trim(), subject, message);
    }

    private static boolean sendEmailCustom(String toEmail, String subject, String messageContent) {
        if (!isValidEmail(toEmail)) {
            System.out.println("[EmailService] Invalid email: " + toEmail);
            return false;
        }
        try {
            System.out.println("[EmailService] Sending email to: " + toEmail);
            System.out.println("[EmailService] Subject: " + subject);
            
            Properties props = new Properties();
            props.put("mail.smtp.auth", "true");
            props.put("mail.smtp.starttls.enable", "true");
            props.put("mail.smtp.host", SMTP_HOST);
            props.put("mail.smtp.port", SMTP_PORT);
            props.put("mail.smtp.ssl.protocols", "TLSv1.2");
            props.put("mail.mime.charset", "UTF-8");

            Authenticator auth = new Authenticator() {
                @Override
                protected PasswordAuthentication getPasswordAuthentication() {
                    return new PasswordAuthentication(FROM_EMAIL, APP_PASSWORD);
                }
            };

            Session session = Session.getInstance(props, auth);
            session.setDebug(false); // Set to true for detailed SMTP logs
            
            MimeMessage message = new MimeMessage(session);
            message.setFrom(new InternetAddress(FROM_EMAIL, "Multi-Restaurant Menu", "UTF-8"));
            message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(toEmail));
            message.setSubject(subject, "UTF-8");
            message.setContent(messageContent, "text/html; charset=utf-8");
            message.saveChanges();

            Transport.send(message);
            System.out.println("[EmailService] Email sent successfully");
            return true;
        } catch (Exception e) {
            System.err.println("[EmailService] Error sending email: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    private static boolean isValidEmail(String email) {
        if (email == null || email.trim().isEmpty()) {
            return false;
        }
        String emailRegex = "^[a-zA-Z0-9_+&*-]+(?:\\.[a-zA-Z0-9_+&*-]+)*@(?:[a-zA-Z0-9-]+\\.)+[a-zA-Z]{2,7}$";
        return email.matches(emailRegex);
    }

    private static String buildApprovalEmail(String ownerName, String restaurantName) {
        return "<!DOCTYPE html>"
                + "<html>"
                + "<head>"
                + "<meta charset='UTF-8'>"
                + "<style>"
                + "body { font-family: Arial, sans-serif; margin: 0; padding: 20px; background-color: #f4f4f4; }"
                + ".container { max-width: 600px; margin: 0 auto; background-color: white; padding: 30px; border-radius: 10px; box-shadow: 0 2px 10px rgba(0,0,0,0.1); }"
                + ".header { text-align: center; margin-bottom: 30px; }"
                + ".logo { font-size: 28px; font-weight: bold; color: #28a745; margin-bottom: 10px; }"
                + ".title { font-size: 24px; font-weight: bold; color: #333; margin-bottom: 20px; }"
                + ".content { line-height: 1.6; color: #555; }"
                + ".highlight { background-color: #d4edda; padding: 15px; border-left: 4px solid #28a745; margin: 20px 0; }"
                + ".footer { margin-top: 30px; padding-top: 20px; border-top: 1px solid #eee; text-align: center; color: #777; font-size: 14px; }"
                + ".button { display: inline-block; background-color: #28a745; color: white; padding: 12px 30px; text-decoration: none; border-radius: 5px; margin: 20px 0; }"
                + "</style>"
                + "</head>"
                + "<body>"
                + "<div class='container'>"
                + "<div class='header'>"
                + "<div class='logo'>🍽️ Multi Restaurant Menu</div>"
                + "</div>"
                + "<div class='title'>Congratulations! Your Restaurant Has Been Approved</div>"
                + "<div class='content'>"
                + "<p>Dear <strong>" + ownerName + "</strong>,</p>"
                + "<p>We are thrilled to inform you that your restaurant application for <strong>" + restaurantName + "</strong> has been <span style='color: #28a745; font-weight: bold;'>APPROVED</span>!</p>"
                + "<div class='highlight'>"
                + "<h3>What's Next?</h3>"
                + "<ul>"
                + "<li>Your restaurant is now live on our platform</li>"
                + "<li>You can start adding menu items and managing your restaurant</li>"
                + "<li>Customers can now discover and order from your restaurant</li>"
                + "</ul>"
                + "</div>"
                + "<p>You can now log in to your restaurant dashboard to start managing your restaurant's menu, orders, and settings.</p>"
                + "<p>If you have any questions or need assistance, please don't hesitate to contact our support team.</p>"
                + "<p>Thank you for choosing Multi Restaurant Menu platform!</p>"
                + "</div>"
                + "<div class='footer'>"
                + "<p>Best regards,<br>The Multi Restaurant Menu Team</p>"
                + "<p><small>This is an automated message. Please do not reply to this email.</small></p>"
                + "</div>"
                + "</div>"
                + "</body>"
                + "</html>";
    }

    private static String buildRejectionEmail(String ownerName, String restaurantName, String rejectionReason) {
        return "<!DOCTYPE html>"
                + "<html>"
                + "<head>"
                + "<meta charset='UTF-8'>"
                + "<style>"
                + "body { font-family: Arial, sans-serif; margin: 0; padding: 20px; background-color: #f4f4f4; }"
                + ".container { max-width: 600px; margin: 0 auto; background-color: white; padding: 30px; border-radius: 10px; box-shadow: 0 2px 10px rgba(0,0,0,0.1); }"
                + ".header { text-align: center; margin-bottom: 30px; }"
                + ".logo { font-size: 28px; font-weight: bold; color: #dc3545; margin-bottom: 10px; }"
                + ".title { font-size: 24px; font-weight: bold; color: #333; margin-bottom: 20px; }"
                + ".content { line-height: 1.6; color: #555; }"
                + ".rejection-box { background-color: #f8d7da; padding: 20px; border-left: 4px solid #dc3545; margin: 20px 0; border-radius: 5px; }"
                + ".reason-title { font-weight: bold; color: #721c24; margin-bottom: 10px; }"
                + ".reason-text { background-color: #fff; padding: 15px; border-radius: 5px; margin-top: 10px; border: 1px solid #f5c6cb; }"
                + ".footer { margin-top: 30px; padding-top: 20px; border-top: 1px solid #eee; text-align: center; color: #777; font-size: 14px; }"
                + ".button { display: inline-block; background-color: #007bff; color: white; padding: 12px 30px; text-decoration: none; border-radius: 5px; margin: 20px 0; }"
                + "</style>"
                + "</head>"
                + "<body>"
                + "<div class='container'>"
                + "<div class='header'>"
                + "<div class='logo'>🍽️ Multi Restaurant Menu</div>"
                + "</div>"
                + "<div class='title'>Restaurant Application Update</div>"
                + "<div class='content'>"
                + "<p>Dear <strong>" + ownerName + "</strong>,</p>"
                + "<p>We regret to inform you that your restaurant application for <strong>" + restaurantName + "</strong> has been <span style='color: #dc3545; font-weight: bold;'>REJECTED</span>.</p>"
                + "<div class='rejection-box'>"
                + "<div class='reason-title'>Reason for Rejection:</div>"
                + "<div class='reason-text'>" + escapeHtml(rejectionReason) + "</div>"
                + "</div>"
                + "<h3>What You Can Do:</h3>"
                + "<ul>"
                + "<li>Review the feedback provided above</li>"
                + "<li>Make the necessary changes to your application</li>"
                + "<li>Submit a new application with the corrections</li>"
                + "</ul>"
                + "<p>We encourage you to address the issues mentioned and reapply. Our goal is to help you successfully join our platform.</p>"
                + "<p>If you have any questions about the rejection or need clarification on the feedback, please feel free to contact our support team.</p>"
                + "<p>Thank you for your interest in Multi Restaurant Menu platform.</p>"
                + "</div>"
                + "<div class='footer'>"
                + "<p>Best regards,<br>The Multi Restaurant Menu Team</p>"
                + "<p><small>This is an automated message. Please do not reply to this email.</small></p>"
                + "</div>"
                + "</div>"
                + "</body>"
                + "</html>";
    }

    private static String buildComplaintStatusEmail(String ownerName, String restaurantName,
            int complaintId, String status, String adminNote) {
        return "<!DOCTYPE html>"
                + "<html>"
                + "<head>"
                + "<meta charset='UTF-8'>"
                + "<style>"
                + "body { font-family: Arial, sans-serif; margin: 0; padding: 20px; background-color: #f4f4f4; }"
                + ".container { max-width: 600px; margin: 0 auto; background-color: white; padding: 30px; border-radius: 10px; box-shadow: 0 2px 10px rgba(0,0,0,0.1); }"
                + ".title { font-size: 22px; font-weight: bold; color: #333; margin-bottom: 20px; }"
                + ".content { line-height: 1.6; color: #555; }"
                + ".status { display: inline-block; padding: 6px 12px; border-radius: 6px; background-color: #eef2ff; color: #1e3a8a; font-weight: bold; }"
                + ".note-box { background-color: #f8fafc; padding: 15px; border: 1px solid #e2e8f0; border-radius: 8px; margin-top: 10px; white-space: pre-wrap; }"
                + ".footer { margin-top: 30px; padding-top: 20px; border-top: 1px solid #eee; text-align: center; color: #777; font-size: 14px; }"
                + "</style>"
                + "</head>"
                + "<body>"
                + "<div class='container'>"
                + "<div class='title'>Complaint Status Update</div>"
                + "<div class='content'>"
                + "<p>Dear <strong>" + escapeHtml(ownerName) + "</strong>,</p>"
                + "<p>The complaint related to your restaurant <strong>" + escapeHtml(restaurantName) + "</strong> has been updated by admin.</p>"
                + "<p>Complaint ID: <strong>#" + complaintId + "</strong></p>"
                + "<p>New status: <span class='status'>" + escapeHtml(status) + "</span></p>"
                + "<p>Admin note:</p>"
                + "<div class='note-box'>" + escapeHtml(adminNote) + "</div>"
                + "</div>"
                + "<div class='footer'>"
                + "<p>Best regards,<br>The Multi Restaurant Menu Team</p>"
                + "<p><small>This is an automated message. Please do not reply to this email.</small></p>"
                + "</div>"
                + "</div>"
                + "</body>"
                + "</html>";
    }

    private static String escapeHtml(String text) {
        if (text == null) return "";
        return text.replace("&", "&amp;")
                  .replace("<", "&lt;")
                  .replace(">", "&gt;")
                  .replace("\"", "&quot;")
                  .replace("'", "&#x27;");
    }
}
