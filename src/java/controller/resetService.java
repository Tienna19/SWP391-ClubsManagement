package controller;

import java.sql.Timestamp;
import java.time.LocalDateTime;
import java.util.Properties;
import java.util.UUID;
import javax.mail.*;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeMessage;

public class resetService {
    private final int LIMIT_MINUS = 10;
    static final String from = "huonghieunghia2@gmail.com";
    static final String password = "tzii wzmv bbke wzjv";

    public String generateToken() {
        return UUID.randomUUID().toString();
    }

    public Timestamp expireDateTime() {
        return Timestamp.valueOf(LocalDateTime.now().plusMinutes(LIMIT_MINUS));
    }

    public boolean isExpireTime(Timestamp time) {
        return new Timestamp(System.currentTimeMillis()).after(time);
    }

    public boolean sendEmail(String to, String link, String name) {
        Properties props = new Properties();
        props.put("mail.smtp.host", "smtp.gmail.com");
        props.put("mail.smtp.port", "587");
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.starttls.enable", "true");

        Authenticator auth = new Authenticator() {
            @Override
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(from, password);
            }
        };

        Session session = Session.getInstance(props, auth);

        try {
            MimeMessage msg = new MimeMessage(session);
            msg.addHeader("Content-type", "text/html; charset=UTF-8");
            msg.setFrom(from);
            msg.setRecipients(Message.RecipientType.TO, InternetAddress.parse(to, false));
            msg.setSubject("Reset Password", "UTF-8");

            String content = "<h1>Xin chào, " + name + "</h1>"
                    + "<p>Hãy ấn vào đây để đổi mật khẩu: "
                    + "<a href=" + link + ">Nhấn vào đây</a></p>";

            msg.setContent(content, "text/html; charset=UTF-8");
            Transport.send(msg);
            System.out.println("✅ Gửi email thành công!");
            return true;
        } catch (Exception e) {
            System.out.println("❌ Gửi email thất bại: " + e);
            return false;
        }
    }
}
