package com.munited.munited.model;

import jakarta.persistence.*;
import lombok.*;

import java.time.LocalDateTime;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

/**
 * Event repräsentiert
 *
 * @author Nico Harbig
 */
@Entity
@Table(name = "events")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@EqualsAndHashCode
public class Event {
    /**
     * Eindeutige ID des Events. Wird von der Datenbank generiert.
     */
    private @Id
    @GeneratedValue Long id;

    /**
     * Titel eines Events.
     */
    @Column(nullable = false)
    private String title;

    /**
     * Icon eines Events. Wird per Name auf Material-Icons im Frontend gemappt.
     */
    @Column(nullable = false)
    private String icon;

    /**
     * Startzeit eines Events.
     */
    @Column(nullable = false)
    private LocalDateTime start;

    /**
     * Beschreibung eines Events.
     */
    @Column(nullable = false)
    private String description;

    /**
     * Optionale maximale Anzahl an Besuchern.
     */
    @Column(nullable = true)
    private int maxVisitors;

    /**
     * Optionale Kosten des Events, die jeder Besucher tragen muss.
     */
    @Column(nullable = true)
    private double costs;

    /**
     * Optionale Labels des Events.
     */
    @ElementCollection
    @CollectionTable(name = "labels_events")
    @Column(nullable = true)
    private List<String> labels;

    @ManyToMany
    @JoinTable(
            name = "registrations",
            joinColumns = @JoinColumn(name = "event_id"),
            inverseJoinColumns = @JoinColumn(name = "user_id")
    )
    private Set<User> visitors = new HashSet<>();

    @ManyToOne(optional = false, fetch = FetchType.EAGER)
    private User creator;
}
