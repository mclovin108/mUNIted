package com.munited.munited.database;

import com.munited.munited.model.Event;
import org.springframework.data.jpa.repository.JpaRepository;

/**
 * EventRepository repräsentiert
 *
 * @author Nico Harbig
 */
public interface EventRepository extends JpaRepository<Event, Long> {
}
