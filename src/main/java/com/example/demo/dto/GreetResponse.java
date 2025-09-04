package com.example.demo.dto;

public class GreetResponse {
    private String message;
    private String at;

    public GreetResponse() {
    }

    public GreetResponse(String message, String at) {
        this.message = message;
        this.at = at;
    }

    public String getMessage() {
        return message;
    }

    public void setMessage(String message) {
        this.message = message;
    }

    public String getAt() {
        return at;
    }

    public void setAt(String at) {
        this.at = at;
    }
}
