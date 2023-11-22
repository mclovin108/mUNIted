package com.munited.munited.model;

import jakarta.persistence.*;

/**
 * User repräsentiert einen Benutzer der App. Dieser hat eine E-Mail, einen Benutzernamen und ein Passwort.
 * Damit kann sich der Nutzer in der App anmelden.
 *
 * @author Nico Harbig
 */
@Entity
@Table(name = "users")
public class User {
    /**
     * Eindeutige ID des Benutzers. Wird von der Datenbank generiert
     */
    private @Id @GeneratedValue Long id;

    /**
     * Benutzername des Benutzers. Dieser ist nicht eindeutig
     */
    @Column(nullable = false)
    private String username;
    /**
     * Email des Benutzers. Diese ist eindeutig
     */
    @Column(unique = true, nullable = false)
    private String email;
    /**
     * Passwort des Benutzers. Wird nur gehasht gespeichert
     */
    @Column(nullable = false)
    private String password;
    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }
}
