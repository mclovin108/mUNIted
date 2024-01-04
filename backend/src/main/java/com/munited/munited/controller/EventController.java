package com.munited.munited.controller;

import com.munited.munited.controller.requests.EventBody;
import com.munited.munited.database.EventRepository;
import com.munited.munited.database.UserRepository;
import com.munited.munited.model.Event;
import com.munited.munited.model.User;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.server.ResponseStatusException;

import java.util.HashSet;
import java.util.List;
import java.util.Optional;

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
        Optional<Event> optEvent = eventRepository.findById(id);
        if (optEvent.isEmpty()) {
            throw new ResponseStatusException(
                    HttpStatus.NOT_FOUND, "User not found"
            );
        }
        return optEvent.get();
    }

    @PostMapping("/events")
    Event createEvent(@RequestBody EventBody body) {
        Optional<User> optUser = userRepository.findById(body.getCreatorId());
        if (optUser.isEmpty()) {
            throw new ResponseStatusException(
                    HttpStatus.NOT_FOUND, "User not found"
            );
        }
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
    public void deleteById(@PathVariable("id") Long id) {
        if (!eventRepository.existsById(id)) {
            throw new ResponseStatusException(
                    HttpStatus.NOT_FOUND, "Event not found"
            );
        }
        eventRepository.deleteById(id);
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
        Event event = eventRepository.findById(eventId)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Event not found"));
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Event not found"));
        if(user.getSignedUpEvents() == null) {
            user.setSignedUpEvents(new HashSet<>());
        }
        if (!user.getSignedUpEvents().contains(event)) {
            user.getSignedUpEvents().add(event);
            userRepository.save(user);
            if (event.getVisitors() == null) {
                event.setVisitors(new HashSet<>());
            }
            event.getVisitors().add(user);
            eventRepository.save(event);
        }
        return event;
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
        Event event = eventRepository.findById(eventId)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Event not found"));
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Event not found"));
        if(user.getSignedUpEvents() == null) {
            throw new ResponseStatusException(HttpStatus.NOT_FOUND, "User is not signed up to this event");
        }
        if (user.getSignedUpEvents().contains(event)) {
            user.getSignedUpEvents().remove(event);
            userRepository.save(user);
            if (event.getVisitors() == null) {
                event.setVisitors(new HashSet<>());
            }
            event.getVisitors().remove(user);
            eventRepository.save(event);
        }
        return event;
    }
}
