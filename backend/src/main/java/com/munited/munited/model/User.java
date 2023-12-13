package com.munited.munited.model;

import com.fasterxml.jackson.annotation.*;
import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.util.Set;

/**
 * User repräsentiert einen Benutzer der App. Dieser hat eine E-Mail, einen Benutzernamen und ein Passwort.
 * Damit kann sich der Nutzer in der App anmelden.
 *
 * @author Nico Harbig
 */
@Entity
@Table(name = "users")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
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

    @ManyToMany(fetch = FetchType.EAGER, cascade = CascadeType.ALL)
    @JoinTable(name = "registrations",
    joinColumns = {
            @JoinColumn(name = "user_id", referencedColumnName = "id")
    },
    inverseJoinColumns = {
            @JoinColumn(name = "event_id", referencedColumnName = "id")
    })
    @JsonIgnore
    private Set<Event> signedUpEvents;

    @JsonIgnore
    @OneToMany(mappedBy = "creator", fetch = FetchType.EAGER)
    private Set<Event> createdEvents;
}
