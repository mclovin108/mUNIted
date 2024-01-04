package com.munited.munited.controller;

import com.munited.munited.controller.requests.EventBody;
import com.munited.munited.database.EventRepository;
import com.munited.munited.database.UserRepository;
import com.munited.munited.model.Event;
import com.munited.munited.model.User;
import org.junit.jupiter.api.AfterEach;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.MockitoAnnotations;

import java.time.LocalDateTime;
import java.time.Month;
import java.util.*;


import org.springframework.http.HttpStatus;
import org.springframework.web.server.ResponseStatusException;

import java.util.Collections;

import static org.assertj.core.api.AssertionsForClassTypes.catchThrowable;
import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.BDDMockito.given;
import static org.mockito.Mockito.*;

/**
 * EventControllerTest repräsentiert
 *
 * @author Nico Harbig
 */
public class EventControllerTest {
    @Mock
    private UserRepository userRepository;
    @Mock
    private EventRepository eventRepository;
    @InjectMocks
    private EventController eventController;
    private User user;
    private Event event;
    private EventBody body;
    private AutoCloseable mockClosable;

    @BeforeEach
    public void setup() {
        mockClosable = MockitoAnnotations.openMocks(this);

        // Testdaten
        user = new User();
        user.setId(1L);
        user.setUsername("testUser");
        user.setEmail("test@example.com");
        user.setPassword("password");

        body = new EventBody(
                "title",
                "icon",
                LocalDateTime.of(2023, Month.JANUARY, 12, 05, 50),
                "description",
                10,
                20,
                Collections.singletonList("hello"),
                1L
        );

        event = new Event();
        event.setTitle("title");
        event.setIcon("icon");
        event.setStart(LocalDateTime.of(2023, Month.JANUARY, 12, 05, 50));
        event.setDescription("description");
        event.setMaxVisitors(10);
        event.setCosts(20);
        event.setLabels(Collections.singletonList("hello"));
        event.setCreator(user);
    }

    @AfterEach
    public void tearDown() throws Exception {
        mockClosable.close();
    }

    @Test
    public void testAllEvents() {
        given(eventRepository.findAll()).willReturn(Collections.singletonList(event));

        List<Event> allEvents = eventController.allEvents();

        assertEquals(1, allEvents.size());
        assertEquals(event, allEvents.getFirst());

        verify(eventRepository, times(1)).findAll();
    }

    @Test
    public void testGetEvent() {
        given(eventRepository.findById(any(Long.class))).willReturn(Optional.of(event));

        Event foundEvent = eventController.getEvent(1L);

        assertEquals(event, foundEvent);

        verify(eventRepository, times(1)).findById(any(Long.class));
    }

    @Test
    public void testGetEventNotFound() {
        given(eventRepository.findById(any(Long.class))).willReturn(Optional.empty());

        Throwable thrown = catchThrowable(() -> eventController.getEvent(1L));

        assertInstanceOf(ResponseStatusException.class, thrown);
        assertEquals(HttpStatus.NOT_FOUND, ((ResponseStatusException) thrown).getStatusCode());

        verify(eventRepository, times(1)).findById(any(Long.class));
    }

    @Test
    public void testCreateEvent() {
        given(userRepository.findById(any(Long.class))).willReturn(Optional.of(user));
        given(eventRepository.save(event)).willReturn(event);

        Event createdEvent = eventController.createEvent(body);

        assertEquals(event, createdEvent);

        verify(eventRepository, times(1)).save(any(Event.class));
    }

    @Test
    public void testCreateEventUserNotFound() {
        given(userRepository.findById(any(Long.class))).willReturn(Optional.empty());
        given(eventRepository.save(event)).willReturn(event);

        Throwable thrown = catchThrowable(() -> eventController.createEvent(body));

        assertInstanceOf(ResponseStatusException.class, thrown);
        assertEquals(HttpStatus.NOT_FOUND, ((ResponseStatusException) thrown).getStatusCode());

        verify(eventRepository, times(0)).save(any(Event.class));
    }

    @Test
    public void testReplaceEvent() {
        given(eventRepository.findById(any(Long.class))).willReturn(Optional.of(event));
        given(eventRepository.save(any(Event.class))).willReturn(event);

        Event updatedEvent = event;
        updatedEvent.setTitle("newtitle");

        EventBody updatedEventBody = body;
        body.setTitle("newtitle");

        Event actualUpdated = eventController.replaceEvent(updatedEventBody, 1L);

        assertEquals(updatedEvent, actualUpdated);

        verify(eventRepository, times(1)).findById(any(Long.class));
        verify(eventRepository, times(1)).save(any(Event.class));
    }

    @Test
    public void testReplaceEventNotFound() {
        given(eventRepository.findById(any(Long.class))).willReturn(Optional.empty());

        Throwable thrown = catchThrowable(() -> eventController.replaceEvent(body, 1L));

        assertInstanceOf(ResponseStatusException.class, thrown);
        assertEquals(HttpStatus.NOT_FOUND, ((ResponseStatusException) thrown).getStatusCode());

        verify(eventRepository, times(1)).findById(any(Long.class));
    }

    @Test
    public void testDeleteById() {
        given(eventRepository.existsById(any(Long.class))).willReturn(true);

        eventController.deleteById(1L);

        verify(eventRepository, times(1)).deleteById(any(Long.class));
    }


    @Test
    public void testDeleteByIdNotFound() {
        given(eventRepository.existsById(any(Long.class))).willReturn(false);

        Throwable thrown = catchThrowable(() -> eventController.deleteById(1L));

        assertInstanceOf(ResponseStatusException.class, thrown);
        assertEquals(HttpStatus.NOT_FOUND, ((ResponseStatusException) thrown).getStatusCode());

        verify(eventRepository, times(0)).deleteById(any(Long.class));
    }

    @Test
    public void testSignUpToEvent() {
        given(eventRepository.findById(1L)).willReturn(Optional.of(event));
        given(userRepository.findById(1L)).willReturn(Optional.of(user));
        given(userRepository.save(user)).willReturn(user);
        Event eventWithUser = event;
        HashSet<User> set = new HashSet<>();
        set.add(user);
        eventWithUser.setVisitors(set);
        given(eventRepository.save(any(Event.class))).willReturn(eventWithUser);

        Event signedUpEvent = eventController.signUpToEvent(1L, 1L);

        assertTrue(signedUpEvent.getVisitors().contains(user));

        verify(eventRepository, times(1)).findById(1L);
        verify(userRepository, times(1)).findById(1L);
        verify(userRepository, times(1)).save(user);
        verify(eventRepository, times(1)).save(event);
    }

    @Test
    public void testSignUpToEventAlreadySignedUp() {
        //Construct event that already has a visitor
        Event eventWithUser = event;
        HashSet<User> set = new HashSet<>();
        set.add(user);
        eventWithUser.setVisitors(set);
        //Construct user that already visits one event
        User userWithEvent = user;
        HashSet<Event> eventSet = new HashSet<>();
        eventSet.add(eventWithUser);
        userWithEvent.setSignedUpEvents(eventSet);

        given(userRepository.findById(1L)).willReturn(Optional.of(userWithEvent));
        given(userRepository.save(any(User.class))).willReturn(userWithEvent);
        given(eventRepository.findById(1L)).willReturn(Optional.of(eventWithUser));
        given(eventRepository.save(any(Event.class))).willReturn(eventWithUser);

        Event signedUpEvent = eventController.signUpToEvent(1L, 1L);

        assertTrue(signedUpEvent.getVisitors().contains(user));
        assertEquals(1, signedUpEvent.getVisitors().size());

        verify(eventRepository, times(1)).findById(1L);
        verify(userRepository, times(1)).findById(1L);
        verify(userRepository, times(0)).save(any(User.class));
        verify(eventRepository, times(0)).save(any(Event.class));
    }

    @Test
    public void testSignUpToEventNoVisitors() {
        given(userRepository.findById(1L)).willReturn(Optional.of(user));
        given(userRepository.save(any(User.class))).willReturn(user);
        given(eventRepository.findById(1L)).willReturn(Optional.of(event));
        given(eventRepository.save(any(Event.class))).willReturn(event);

        Event signedUpEvent = eventController.signUpToEvent(1L, 1L);

        assertTrue(signedUpEvent.getVisitors().contains(user));
        assertEquals(1, signedUpEvent.getVisitors().size());

        verify(eventRepository, times(1)).findById(1L);
        verify(userRepository, times(1)).findById(1L);
        verify(userRepository, times(1)).save(any(User.class));
        verify(eventRepository, times(1)).save(any(Event.class));
    }

    @Test
    public void testSignOffFromEventWithSignedUpUser() {
        HashSet<User> visitors = new HashSet<>();
        visitors.add(user);
        event.setVisitors(visitors);
        HashSet<Event> events = new HashSet<>();
        events.add(event);
        user.setSignedUpEvents(events);

        given(eventRepository.findById(1L)).willReturn(Optional.of(event));
        given(userRepository.findById(1L)).willReturn(Optional.of(user));

        Event signedOffEvent = eventController.signOffFromEvent(1L, 1L);

        assertFalse(signedOffEvent.getVisitors().contains(user));
        assertFalse(user.getSignedUpEvents().contains(event));

        verify(userRepository).save(user);
        verify(eventRepository).save(event);
    }

    @Test
    public void testSignOffFromEventWithNoSignedUpUserThrows() {
        given(eventRepository.findById(1L)).willReturn(Optional.of(event));
        given(userRepository.findById(1L)).willReturn(Optional.of(user));

        Throwable thrown = catchThrowable(() -> eventController.signOffFromEvent(1L, 1L));

        assertInstanceOf(ResponseStatusException.class, thrown);
        assertEquals(HttpStatus.NOT_FOUND, ((ResponseStatusException) thrown).getStatusCode());

        verify(userRepository, times(0)).save(user);
        verify(eventRepository, times(0)).save(event);
    }

    @Test
    public void testSignOffFromEventWithNoSignedUpUser() {
        User withEvents = user;
        user.setSignedUpEvents(new HashSet<>());
        given(eventRepository.findById(1L)).willReturn(Optional.of(event));
        given(userRepository.findById(1L)).willReturn(Optional.of(withEvents));

        Event signedOffEvent = eventController.signOffFromEvent(1L, 1L);

        assertEquals(event, signedOffEvent);

        verify(userRepository, times(0)).save(user);
        verify(eventRepository, times(0)).save(event);
    }

    @Test
    public void testSignOffFromEvent() {
        User withEvents = user;
        HashSet<Event> events = new HashSet<>();
        events.add(event);
        user.setSignedUpEvents(events);
        given(eventRepository.findById(1L)).willReturn(Optional.of(event));
        given(userRepository.findById(1L)).willReturn(Optional.of(withEvents));

        Event signedOffEvent = eventController.signOffFromEvent(1L, 1L);

        assertEquals(event, signedOffEvent);

        verify(userRepository, times(1)).save(user);
        verify(eventRepository, times(1)).save(event);

    }
}
