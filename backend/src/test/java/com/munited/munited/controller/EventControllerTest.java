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
        event.setId(1L);
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
    public void testAllEvents1() {
        given(eventRepository.findAll()).willReturn(Collections.emptyList());
        List<Event> allEvents = eventController.allEvents();
        assertEquals(0, allEvents.size());
        verify(eventRepository, times(1)).findAll();
    }
    @Test
    public void testAllEvents2() {
        ArrayList<Event> toReturn = new ArrayList<>();
        toReturn.add(event);
        toReturn.add(event);
        given(eventRepository.findAll()).willReturn(toReturn);
        List<Event> allEvents = eventController.allEvents();
        assertEquals(2, allEvents.size());
        assertEquals(event, allEvents.getFirst());
        assertEquals(event, allEvents.get(1));
        verify(eventRepository, times(1)).findAll();
    }@Test
    public void testAllEvents3() {
        ArrayList<Event> toReturn = new ArrayList<>();
        toReturn.add(event);
        given(eventRepository.findAll()).willReturn(toReturn);
        List<Event> allEvents = eventController.allEvents();
        assertEquals(1, allEvents.size());
        assertEquals(event, allEvents.getFirst());
        verify(eventRepository, times(1)).findAll();
    }

    @Test
    public void testGetEvent4() {
        given(eventRepository.findById(1L)).willReturn(Optional.of(event));
        Event result = eventController.getEvent(1L);
        assertEquals(event, result);
        verify(eventRepository).findById(1L);
    }

    @Test
    public void testGetEvent5() {
        when(eventRepository.findById(1L)).thenReturn(Optional.empty());

        assertThrows(ResponseStatusException.class, () -> {
            eventController.getEvent(1L);
        });

        verify(eventRepository).findById(1L);
    }


    @Test
    public void testGetEvent6() {
        assertThrows(ResponseStatusException.class, () -> {
            eventController.getEvent(-5L);
        });

        verify(eventRepository, never()).findById(-5L);
    }

    @Test
    public void testGetEvent7() {
        assertThrows(ResponseStatusException.class, () -> {
            eventController.getEvent(null);
        });
        verify(eventRepository, never()).findById(any());
    }
    @Test
    public void testGetEvent8() {
        assertThrows(ResponseStatusException.class, () -> {
            eventController.getEvent(-1L);
        });

        verify(eventRepository, never()).findById(-1L);
    }

    @Test
    public void postEvent9() {
        given(userRepository.findById(any(Long.class))).willReturn(Optional.of(user));
        given(eventRepository.save(any(Event.class))).willReturn(event);

        Event createdEvent = eventController.createEvent(body);

        assertEquals(event, createdEvent);

        verify(eventRepository).save(any(Event.class));
    }

    @Test
    public void postEvent10() {
        given(userRepository.findById(any(Long.class))).willReturn(Optional.empty());
        given(eventRepository.save(any(Event.class))).willReturn(event);

        Throwable thrown = catchThrowable(() -> eventController.createEvent(body));
        assertEquals(HttpStatus.NOT_FOUND, ((ResponseStatusException) thrown).getStatusCode());

        verify(eventRepository, never()).save(any(Event.class));
    }

    @Test
    public void postEvent11() {
        given(userRepository.findById(any(Long.class))).willReturn(Optional.empty());
        given(eventRepository.save(any(Event.class))).willReturn(event);
        EventBody modified = body;
        modified.setCreatorId(-1L);
        Throwable thrown = catchThrowable(() -> eventController.createEvent(modified));
        assertEquals(HttpStatus.BAD_REQUEST, ((ResponseStatusException) thrown).getStatusCode());

        verify(eventRepository, never()).save(any(Event.class));
    }

    @Test
    public void postEvent12() {
        given(userRepository.findById(any(Long.class))).willReturn(Optional.empty());
        given(eventRepository.save(any(Event.class))).willReturn(event);
        EventBody modified = body;
        modified.setCreatorId(null);
        Throwable thrown = catchThrowable(() -> eventController.createEvent(modified));
        assertEquals(HttpStatus.BAD_REQUEST, ((ResponseStatusException) thrown).getStatusCode());

        verify(eventRepository, never()).save(any(Event.class));
    }
    @Test
    public void testReplaceEvent13() {
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
    public void testReplaceEvent14() {
        given(eventRepository.findById(any(Long.class))).willReturn(Optional.empty());

        Throwable thrown = catchThrowable(() -> eventController.replaceEvent(body, 1L));

        assertInstanceOf(ResponseStatusException.class, thrown);
        assertEquals(HttpStatus.NOT_FOUND, ((ResponseStatusException) thrown).getStatusCode());

        verify(eventRepository).findById(any(Long.class));
    }


    @Test
    public void testReplaceEvent15() {
        given(eventRepository.findById(any(Long.class))).willReturn(Optional.empty());

        Throwable thrown = catchThrowable(() -> eventController.replaceEvent(body, -1L));

        assertInstanceOf(ResponseStatusException.class, thrown);
        assertEquals(HttpStatus.BAD_REQUEST, ((ResponseStatusException) thrown).getStatusCode());

        verify(eventRepository, times(0)).findById(any(Long.class));
    }

    @Test
    public void testReplaceEvent16() {
        given(eventRepository.findById(any(Long.class))).willReturn(Optional.empty());

        Throwable thrown = catchThrowable(() -> eventController.replaceEvent(body, null));

        assertInstanceOf(ResponseStatusException.class, thrown);
        assertEquals(HttpStatus.BAD_REQUEST, ((ResponseStatusException) thrown).getStatusCode());

        verify(eventRepository, times(0)).findById(any(Long.class));
    }


    @Test
    public void testDeleteById17() {
        given(eventRepository.findById(1L)).willReturn(Optional.of(event));

        eventController.deleteById(1L);

        verify(eventRepository, times(1)).delete(any(Event.class));
    }


    @Test
    public void testDeleteById18() {
        given(eventRepository.findById(1L)).willReturn(Optional.empty());

        Throwable thrown = catchThrowable(() -> eventController.deleteById(1L));

        assertInstanceOf(ResponseStatusException.class, thrown);
        assertEquals(HttpStatus.NOT_FOUND, ((ResponseStatusException) thrown).getStatusCode());

        verify(eventRepository, times(0)).delete(any(Event.class));
    }

    @Test
    public void testDeleteById19() {
        given(eventRepository.findById(-1L)).willReturn(Optional.empty());

        Throwable thrown = catchThrowable(() -> eventController.deleteById(-1L));

        assertInstanceOf(ResponseStatusException.class, thrown);
        assertEquals(HttpStatus.BAD_REQUEST, ((ResponseStatusException) thrown).getStatusCode());

        verify(eventRepository, times(0)).delete(any(Event.class));
    }


    @Test
    public void testDeleteById20() {
        given(eventRepository.findById(any(Long.class))).willReturn(Optional.empty());

        Throwable thrown = catchThrowable(() -> eventController.deleteById(null));

        assertInstanceOf(ResponseStatusException.class, thrown);
        assertEquals(HttpStatus.BAD_REQUEST, ((ResponseStatusException) thrown).getStatusCode());

        verify(eventRepository, times(0)).delete(any(Event.class));
    }

    @Test
    public void testSignUpToEvent21() {
        given(eventRepository.findById(1L)).willReturn(Optional.of(event));
        given(userRepository.findById(1L)).willReturn(Optional.of(user));
        Event eventWithUser = event;
        HashSet<User> set = new HashSet<>();
        set.add(user);
        eventWithUser.setVisitors(set);
        given(eventRepository.save(any(Event.class))).willReturn(eventWithUser);

        Event signedUpEvent = eventController.signUpToEvent(1L, 1L);

        assertTrue(signedUpEvent.getVisitors().contains(user));

        verify(eventRepository, times(1)).findById(1L);
        verify(userRepository, times(1)).findById(1L);
        verify(eventRepository, times(1)).save(event);
    }


    @Test
    public void testSignUpToEvent22() {
        given(eventRepository.findById(1L)).willReturn(Optional.empty());

        Throwable thrown = catchThrowable(() -> eventController.signUpToEvent(1L, 1L));

        assertInstanceOf(ResponseStatusException.class, thrown);
        assertEquals(HttpStatus.NOT_FOUND, ((ResponseStatusException) thrown).getStatusCode());

        verify(eventRepository, times(1)).findById(1L);
        verify(userRepository, times(0)).findById(1L);
        verify(eventRepository, times(0)).save(event);
    }


    @Test
    public void testSignUpToEvent23() {
        given(eventRepository.findById(1L)).willReturn(Optional.of(event));
        given(userRepository.findById(1L)).willReturn(Optional.empty());

        Throwable thrown = catchThrowable(() -> eventController.signUpToEvent(1L, 1L));

        assertInstanceOf(ResponseStatusException.class, thrown);
        assertEquals(HttpStatus.NOT_FOUND, ((ResponseStatusException) thrown).getStatusCode());

        verify(eventRepository, times(1)).findById(1L);
        verify(userRepository, times(1)).findById(1L);
        verify(eventRepository, times(0)).save(event);
    }

    @Test
    public void testSignUpToEvent24() {
        given(eventRepository.findById(1L)).willReturn(Optional.of(event));
        given(userRepository.findById(1L)).willReturn(Optional.of(user));

        Throwable thrown = catchThrowable(() -> eventController.signUpToEvent(-1L, -1L));

        assertInstanceOf(ResponseStatusException.class, thrown);
        assertEquals(HttpStatus.BAD_REQUEST, ((ResponseStatusException) thrown).getStatusCode());

        verify(eventRepository, times(0)).findById(1L);
        verify(userRepository, times(0)).findById(1L);
        verify(eventRepository, times(0)).save(event);
    }

    @Test
    public void testSignUpToEvent25() {
        given(eventRepository.findById(1L)).willReturn(Optional.of(event));
        given(userRepository.findById(1L)).willReturn(Optional.of(user));

        Throwable thrown = catchThrowable(() -> eventController.signUpToEvent(null, null));

        assertInstanceOf(ResponseStatusException.class, thrown);
        assertEquals(HttpStatus.BAD_REQUEST, ((ResponseStatusException) thrown).getStatusCode());

        verify(eventRepository, times(0)).findById(1L);
        verify(userRepository, times(0)).findById(1L);
        verify(eventRepository, times(0)).save(event);
    }

    @Test
    public void testSignUpToEvent26() {
        given(eventRepository.findById(1L)).willReturn(Optional.of(event));
        given(userRepository.findById(1L)).willReturn(Optional.of(user));

        Throwable thrown = catchThrowable(() -> eventController.signUpToEvent(1L, null));

        assertInstanceOf(ResponseStatusException.class, thrown);
        assertEquals(HttpStatus.BAD_REQUEST, ((ResponseStatusException) thrown).getStatusCode());

        verify(eventRepository, times(0)).findById(1L);
        verify(userRepository, times(0)).findById(1L);
        verify(eventRepository, times(0)).save(event);
    }

    @Test
    public void testSignUpToEvent27() {
        given(eventRepository.findById(1L)).willReturn(Optional.of(event));
        given(userRepository.findById(1L)).willReturn(Optional.of(user));

        Throwable thrown = catchThrowable(() -> eventController.signUpToEvent(1L, -1L));

        assertInstanceOf(ResponseStatusException.class, thrown);
        assertEquals(HttpStatus.BAD_REQUEST, ((ResponseStatusException) thrown).getStatusCode());

        verify(eventRepository, times(0)).findById(1L);
        verify(userRepository, times(0)).findById(1L);
        verify(eventRepository, times(0)).save(event);
    }

    @Test
    public void testSignOffFromEvent28() {
        given(eventRepository.findById(1L)).willReturn(Optional.of(event));
        given(userRepository.findById(1L)).willReturn(Optional.of(user));
        Event eventWithUser = event;
        HashSet<User> set = new HashSet<>();
        set.add(user);
        eventWithUser.setVisitors(set);
        given(eventRepository.save(any(Event.class))).willReturn(eventWithUser);

        Event signedUpEvent = eventController.signOffFromEvent(1L, 1L);

        assertFalse(signedUpEvent.getVisitors().contains(user));

        verify(eventRepository, times(1)).findById(1L);
        verify(userRepository, times(1)).findById(1L);
        verify(eventRepository, times(1)).save(event);
    }


    @Test
    public void testSignOffFromEvent29() {
        given(eventRepository.findById(1L)).willReturn(Optional.empty());

        Throwable thrown = catchThrowable(() -> eventController.signOffFromEvent(1L, 1L));

        assertInstanceOf(ResponseStatusException.class, thrown);
        assertEquals(HttpStatus.NOT_FOUND, ((ResponseStatusException) thrown).getStatusCode());

        verify(eventRepository, times(1)).findById(1L);
        verify(userRepository, times(0)).findById(1L);
        verify(eventRepository, times(0)).save(event);
    }


    @Test
    public void testSignOffFromEvent30() {
        given(eventRepository.findById(1L)).willReturn(Optional.of(event));
        given(userRepository.findById(1L)).willReturn(Optional.empty());

        Throwable thrown = catchThrowable(() -> eventController.signOffFromEvent(1L, 1L));

        assertInstanceOf(ResponseStatusException.class, thrown);
        assertEquals(HttpStatus.NOT_FOUND, ((ResponseStatusException) thrown).getStatusCode());

        verify(eventRepository, times(1)).findById(1L);
        verify(userRepository, times(1)).findById(1L);
        verify(eventRepository, times(0)).save(event);
    }

    @Test
    public void testSignOffFromEvent31() {
        given(eventRepository.findById(1L)).willReturn(Optional.of(event));
        given(userRepository.findById(1L)).willReturn(Optional.of(user));

        Throwable thrown = catchThrowable(() -> eventController.signOffFromEvent(-1L, -1L));

        assertInstanceOf(ResponseStatusException.class, thrown);
        assertEquals(HttpStatus.BAD_REQUEST, ((ResponseStatusException) thrown).getStatusCode());

        verify(eventRepository, times(0)).findById(1L);
        verify(userRepository, times(0)).findById(1L);
        verify(eventRepository, times(0)).save(event);
    }

    @Test
    public void testSignOffFromEvent32() {
        given(eventRepository.findById(1L)).willReturn(Optional.of(event));
        given(userRepository.findById(1L)).willReturn(Optional.of(user));

        Throwable thrown = catchThrowable(() -> eventController.signOffFromEvent(null, null));

        assertInstanceOf(ResponseStatusException.class, thrown);
        assertEquals(HttpStatus.BAD_REQUEST, ((ResponseStatusException) thrown).getStatusCode());

        verify(eventRepository, times(0)).findById(1L);
        verify(userRepository, times(0)).findById(1L);
        verify(eventRepository, times(0)).save(event);
    }


    @Test
    public void testSignOffFromEvent33() {
        given(eventRepository.findById(1L)).willReturn(Optional.of(event));
        given(userRepository.findById(1L)).willReturn(Optional.of(user));

        Throwable thrown = catchThrowable(() -> eventController.signOffFromEvent(1L, null));

        assertInstanceOf(ResponseStatusException.class, thrown);
        assertEquals(HttpStatus.BAD_REQUEST, ((ResponseStatusException) thrown).getStatusCode());

        verify(eventRepository, times(0)).findById(1L);
        verify(userRepository, times(0)).findById(1L);
        verify(eventRepository, times(0)).save(event);
    }

    @Test
    public void testSignOffFromEvent34() {
        given(eventRepository.findById(1L)).willReturn(Optional.of(event));
        given(userRepository.findById(1L)).willReturn(Optional.of(user));

        Throwable thrown = catchThrowable(() -> eventController.signOffFromEvent(1L, -1L));

        assertInstanceOf(ResponseStatusException.class, thrown);
        assertEquals(HttpStatus.BAD_REQUEST, ((ResponseStatusException) thrown).getStatusCode());

        verify(eventRepository, times(0)).findById(1L);
        verify(userRepository, times(0)).findById(1L);
        verify(eventRepository, times(0)).save(event);
    }
}
