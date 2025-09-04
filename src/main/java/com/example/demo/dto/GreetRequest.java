/**
 * This file is part of the example project.
 * It defines the GreetRequest data transfer object (DTO).
 */
package com.example.demo.dto;

/**
 * GreetRequest represents a request for a greeting message.
 */
public class GreetRequest {

    /**
     * The name of the person to greet.
     */
    private String name;

    /**
     * Destination
     */
    public GreetRequest() {
    }

    /**
     * Destination
     */
    public GreetRequest(String name) {
        this.name = name;
    }

    /**
     * Destination
     */
    public String getName() {
        return name;
    }

    /**
     * Destination
     */
    public void setName(String name) {
        this.name = name;
    }
}
