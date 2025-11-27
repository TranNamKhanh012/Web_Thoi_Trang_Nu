package entity;

import java.sql.Timestamp;

public class Feedback {

    private int id;
    private int userId;
    private String subject;
    private String message;
    private Timestamp receivedDate;
    private String status;
    private String userName; // Tên user từ bảng users
    private String userEmail; // Email user từ bảng users

    public Feedback() {
    }

    public Feedback(int id, int userId, String subject, String message, Timestamp receivedDate, String status, String userName, String userEmail) {
        this.id = id;
        this.userId = userId;
        this.subject = subject;
        this.message = message;
        this.receivedDate = receivedDate;
        this.status = status;
        this.userName = userName;
        this.userEmail = userEmail;
    }

    // Getters and Setters (Alt + Insert)
    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getUserName() {
        return userName;
    }

    public void setUserName(String userName) {
        this.userName = userName;
    }

    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

    public String getUserEmail() {
        return userEmail;
    }

    public void setUserEmail(String userEmail) {
        this.userEmail = userEmail;
    }

    public String getSubject() {
        return subject;
    }

    public void setSubject(String subject) {
        this.subject = subject;
    }

    public String getMessage() {
        return message;
    }

    public void setMessage(String message) {
        this.message = message;
    }

    public Timestamp getReceivedDate() {
        return receivedDate;
    }

    public void setReceivedDate(Timestamp receivedDate) {
        this.receivedDate = receivedDate;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }
}
