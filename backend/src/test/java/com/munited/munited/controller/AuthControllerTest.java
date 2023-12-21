package com.munited.munited.controller;

import com.munited.munited.controller.requests.LoginBody;
import com.munited.munited.controller.requests.RegisterBody;
import com.munited.munited.database.UserRepository;
import com.munited.munited.model.User;
import org.junit.jupiter.api.AfterEach;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.MockitoAnnotations;
import org.springframework.data.domain.Example;
import org.springframework.http.HttpStatus;
import org.springframework.web.server.ResponseStatusException;

import java.util.Collections;
import java.util.List;
import java.util.Optional;

import static org.assertj.core.api.AssertionsForClassTypes.catchThrowable;
import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertInstanceOf;
import static org.mockito.BDDMockito.given;
import static org.mockito.Mockito.*;

/**
 * AuthControllerTest repräsentiert
 *
 * @author Nico Harbig
 */
public class AuthControllerTest {
    @Mock
    private UserRepository repository;

    @InjectMocks
    private AuthController authController;

    private User user;
    private RegisterBody registerBody;
    private LoginBody loginBody;
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

        registerBody = new RegisterBody("testUser", "test@example.com", "password");

        loginBody = new LoginBody("test@example.com", "password");
    }

    @AfterEach
    public void tearDown() throws Exception {
        mockClosable.close();
    }

    @Test
    public void testRegister() {
        given(repository.save(any(User.class))).willReturn(user);

        User createdUser = authController.register(registerBody);

        assertEquals(createdUser.getEmail(), user.getEmail());
        assertEquals(createdUser.getPassword(), user.getPassword());
        assertEquals(createdUser.getUsername(), user.getUsername());
        assertEquals(1, createdUser.getId());

        verify(repository, times(1)).save(any(User.class));
    }

    @Test
    public void testLogin() {
        given(repository.findAll(any(Example.class))).willReturn(Collections.singletonList(user));

        User loggedInUser = authController.login(loginBody);

        assertEquals(loggedInUser.getEmail(), user.getEmail());
        assertEquals(loggedInUser.getPassword(), user.getPassword());
        assertEquals(loggedInUser.getUsername(), user.getUsername());
        assertEquals(1, loggedInUser.getId());

        verify(repository, times(1)).findAll(any(Example.class));
    }

    @Test
    public void testLoginNoUser() {
        given(repository.findAll(any(Example.class))).willReturn(Collections.emptyList());

        Throwable thrown = catchThrowable(() -> authController.login(loginBody));

        assertInstanceOf(ResponseStatusException.class, thrown);
        assertEquals(HttpStatus.NOT_FOUND, ((ResponseStatusException) thrown).getStatusCode());

        verify(repository, times(1)).findAll(any(Example.class));
    }

    @Test
    public void testGetUserById() {
        given(repository.findById(any(Long.class))).willReturn(Optional.of(user));

        User foundUser = authController.getUserById(1L);

        assertEquals(foundUser.getEmail(), user.getEmail());
        assertEquals(foundUser.getPassword(), user.getPassword());
        assertEquals(foundUser.getUsername(), user.getUsername());
        assertEquals(1, foundUser.getId());


        verify(repository, times(1)).findById(any(Long.class));
    }

    @Test
    public void testGetUserByIdNotFound() {
        given(repository.findById(any(Long.class))).willReturn(Optional.empty());

        Throwable thrown = catchThrowable(() -> authController.getUserById(1L));

        assertInstanceOf(ResponseStatusException.class, thrown);
        assertEquals(HttpStatus.NOT_FOUND, ((ResponseStatusException) thrown).getStatusCode());

        verify(repository, times(1)).findById(any(Long.class));
    }

    @Test
    public void testGetUsers() {
        given(repository.findAll()).willReturn(Collections.singletonList(user));

        List<User> users = authController.getUsers();

        assertEquals(1, users.size());
        User foundUser = users.getFirst();
        assertEquals(foundUser.getEmail(), user.getEmail());
        assertEquals(foundUser.getPassword(), user.getPassword());
        assertEquals(foundUser.getUsername(), user.getUsername());
        assertEquals(1, foundUser.getId());

        verify(repository, times(1)).findAll();
    }
}
