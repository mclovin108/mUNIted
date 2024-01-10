package com.munited.munited.controller;

import com.munited.munited.controller.requests.EventBody;
import com.munited.munited.database.EventRepository;
import com.munited.munited.database.UserRepository;
import com.munited.munited.model.Event;
import com.munited.munited.model.User;
import jakarta.transaction.Transactional;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.web.ErrorResponseException;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.server.ResponseStatusException;

import java.util.HashSet;
import java.util.List;
import java.util.Optional;
import java.util.Set;

/**
 * EventController repräsentiert den Controller, der Events verwaltet.
 *
 * @author Nico Harbig
 */
@RestController
public class EventController {
    @Autowired
    private EventRepository eventRepository;

    @Autowired
    private UserRepository userRepository;

    @GetMapping("/events")
    List<Event> allEvents() {
        return eventRepository.findAll();
    }

    @GetMapping("/events/{id}")
    Event getEvent(@PathVariable("id") Long id) {
        if(id == null || id < 0) {
            throw new ResponseStatusException(
                    HttpStatus.BAD_REQUEST, "Invalid id"
            );
        }
        Optional<Event> optEvent = eventRepository.findById(id);
        if (optEvent.isEmpty()) {
            throw new ResponseStatusException(
                    HttpStatus.NOT_FOUND, "Event not found"
            );
        }
        return optEvent.get();
    }

    @PostMapping("/events")
    Event createEvent(@RequestBody EventBody body) {
        if(body.getCreatorId() == null || body.getCreatorId() < 0) {
            throw new ResponseStatusException(
                    HttpStatus.BAD_REQUEST, "Invalid id"
            );
        }
        Optional<User> optUser = userRepository.findById(body.getCreatorId());
        if (optUser.isEmpty()) {
            throw new ResponseStatusException(
                    HttpStatus.NOT_FOUND, "User not found"
            );}

        Event event = new Event();
        event.setTitle(body.getTitle());
        event.setIcon(body.getIcon());
        event.setStart(body.getStart());
        event.setDescription(body.getDescription());
        event.setMaxVisitors(body.getMaxVisitors());
        event.setCosts(body.getCosts());
        event.setLabels(body.getLabels());
        event.setCreator(optUser.get());
        event = eventRepository.save(event);
        return event;
    }

    @PutMapping("/events/{id}")
    Event replaceEvent(@RequestBody EventBody body, @PathVariable Long id) {
        if(id == null || id < 0) {
            throw new ResponseStatusException(
                    HttpStatus.BAD_REQUEST, "Invalid id"
            );
        }
        Event event = eventRepository.findById(id)
            .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Event not found"));
        event.setTitle(body.getTitle());
        event.setTitle(body.getTitle());
        event.setIcon(body.getIcon());
        event.setStart(body.getStart());
        event.setDescription(body.getDescription());
        event.setMaxVisitors(body.getMaxVisitors());
        event.setCosts(body.getCosts());
        event.setLabels(body.getLabels());
        return eventRepository.save(event);
    }

    @DeleteMapping("/events/{id}")
    @Transactional
    public void deleteById(@PathVariable("id") Long id) {
        if(id == null || id < 0) {
            throw new ResponseStatusException(
                    HttpStatus.BAD_REQUEST, "Invalid id"
            );
        }
        Event event = eventRepository.findById(id).orElseThrow(() -> new ResponseStatusException(
                HttpStatus.NOT_FOUND, "Event not found"
        ));
        eventRepository.delete(event);
    }

    /**
     * Method used for signing a user in to an event
     *
     * @param eventId die ID des Events, an dem sich ein User anmelden möchte
     * @param userId die ID des Users, der hinzugefügt werden soll
     * @return
     */
    @PostMapping("/events/{eventId}/register/{userId}")
    public Event signUpToEvent(@PathVariable("eventId") Long eventId, @PathVariable("userId") Long userId) {
        if(eventId == null || eventId < 0 || userId == null || userId < 0) {
            throw new ResponseStatusException(
                    HttpStatus.BAD_REQUEST, "Invalid id"
            );
        }
        Event event = eventRepository.findById(eventId)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Event not found"));
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Event not found"));
        Set<User> newVisitors = event.getVisitors();
        newVisitors.add(user);
        return eventRepository.save(event);
    }

    /**
     * Method used for signing a user off from an event
     *
     * @param eventId die ID des Events, von dem sich ein Nutzer abmelden möchte
     * @param userId die ID des Users, der entfernt werden soll
     * @return
     */
    @PostMapping("/events/{eventId}/signoff/{userId}")
    public Event signOffFromEvent(@PathVariable("eventId") Long eventId, @PathVariable("userId") Long userId) {
        if(eventId == null || eventId < 0 || userId == null || userId < 0) {
            throw new ResponseStatusException(
                    HttpStatus.BAD_REQUEST, "Invalid id"
            );
        }
        Event event = eventRepository.findById(eventId)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Event not found"));
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Event not found"));
        Set<User> newVisitors = event.getVisitors();
        newVisitors.remove(user);
        return eventRepository.save(event);
    }
}
