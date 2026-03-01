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

            // Create authenticator
            Authenticator auth = new Authenticator() {
                @Override
                protected PasswordAuthentication getPasswordAuthentication() {
                    return new PasswordAuthentication(FROM_EMAIL, APP_PASSWORD);
                }
            };

            // Create session
            Session session = Session.getInstance(props, auth);

            // Create message
            Message message = new MimeMessage(session);
            message.setFrom(new InternetAddress(FROM_EMAIL, "Multi-Restaurant Menu"));
            message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(toEmail));
            message.setSubject("Reset Your Password - Multi-Restaurant Menu");

            // HTML email content
            String htmlContent = buildEmailContent(resetLink);
            message.setContent(htmlContent, "text/html; charset=utf-8");

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
}
