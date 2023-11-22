package com.munited.munited.controller.requests;

/**
 * LoginBody repräsentiert den Request-Body bei der Login-Anfrage.
 *
 * @author Nico Harbig
 */
public class LoginBody {
    private String email;
    private String password;

    public LoginBody(String email, String password) {
        this.email = email;
        this.password = password;
    }

    public String getEmail() {
        return email;
    }

    public String getPassword() {
        return password;
    }
}
