package com.munited.munited.model;

import com.fasterxml.jackson.annotation.JsonBackReference;
import com.fasterxml.jackson.annotation.JsonIdentityInfo;
import com.fasterxml.jackson.annotation.JsonManagedReference;
import com.fasterxml.jackson.annotation.ObjectIdGenerators;
import jakarta.persistence.*;
import lombok.*;

import java.time.LocalDateTime;
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
    private @Id @GeneratedValue Long id;

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
    @CollectionTable(name="labels_events")
    @Column(nullable = true)
    private List<String> labels;

    @ManyToMany(mappedBy = "signedUpEvents", fetch = FetchType.EAGER)
    private Set<User> visitors;

    @ManyToOne(optional = false, fetch = FetchType.EAGER)
    private User creator;
}
