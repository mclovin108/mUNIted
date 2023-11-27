package com.munited.munited.controller.requests;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;

/**
 * EventSignupBody repräsentiert den Body bei einer Request für die Anmeldung an einem Event.
 *
 * @author Nico Harbig
 */
@Getter
@AllArgsConstructor
@NoArgsConstructor
public class EventSignupBody {
    private Long id;
}
