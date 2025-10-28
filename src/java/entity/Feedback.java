package entity;

import java.sql.Timestamp;

public class Feedback {
    private int id;
    private String name;
    private String email;
    private String subject;
    private String message;
    private Timestamp receivedDate;
    private String status;

    public Feedback() {
    }

    public Feedback(int id, String name, String email, String subject, String message, Timestamp receivedDate, String status) {
        this.id = id;
        this.name = name;
        this.email = email;
        this.subject = subject;
        this.message = message;
        this.receivedDate = receivedDate;
        this.status = status;
    }
    
    

    // Getters and Setters (Alt + Insert)
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    public String getName() { return name; }
    public void setName(String name) { this.name = name; }
    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }
    public String getSubject() { return subject; }
    public void setSubject(String subject) { this.subject = subject; }
    public String getMessage() { return message; }
    public void setMessage(String message) { this.message = message; }
    public Timestamp getReceivedDate() { return receivedDate; }
    public void setReceivedDate(Timestamp receivedDate) { this.receivedDate = receivedDate; }
    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
}