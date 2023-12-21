package com.munited.munited.controller;

import com.munited.munited.controller.requests.LoginBody;
import com.munited.munited.controller.requests.RegisterBody;
import com.munited.munited.database.UserRepository;
import com.munited.munited.model.User;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Example;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.server.ResponseStatusException;

import java.util.List;

/**
 * AuthController repräsentiert den Controller, der sich um das Registrieren und den Login von Nutzern kümmert.
 *
 * @author Nico Harbig
 */
@RestController
public class AuthController {
    @Autowired
    private UserRepository userRepository;

    @PostMapping("/register")
     User register(@RequestBody RegisterBody body) {
        User user = new User();
        user.setUsername(body.getUsername());
        user.setEmail(body.getEmail());
        user.setPassword(body.getPassword());
        return userRepository.save(user);
    }

    @PostMapping("/login")
     User login(@RequestBody LoginBody body) {
        User exampleUser = new User();
        exampleUser.setEmail(body.getEmail());
        exampleUser.setPassword(body.getPassword());
        Example<User> example = Example.of(exampleUser);
        List<User> possibleUsers = userRepository.findAll(example);
        if(possibleUsers.isEmpty()) {
           throw new ResponseStatusException(HttpStatus.NOT_FOUND, "User not found");
        }
        return possibleUsers.getFirst();
    }

    @GetMapping("/users/{id}")
     User getUserById(@PathVariable("id") Long id) {
        return userRepository
                .findById(id)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "User not found"));
    }

    @GetMapping("/users")
    List<User> getUsers() {
        return userRepository.findAll();
    }
}
