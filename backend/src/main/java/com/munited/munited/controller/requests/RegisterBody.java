package com.munited.munited.controller.requests;

/**
 * RegisterBody repräsentiert den Request-Body bei der Register-Anfrage.
 *
 * @author Nico Harbig
 */
public class RegisterBody {
    private String username;
    private String email;
    private String password;

    public RegisterBody(String username, String email, String password) {
        this.username = username;
        this.email = email;
        this.password = password;
    }

    public String getUsername() {
        return username;
    }

    public String getEmail() {
        return email;
    }

    public String getPassword() {
        return password;
    }
}
