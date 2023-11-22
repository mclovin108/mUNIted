package com.munited.munited.database;

import com.munited.munited.model.User;
import org.springframework.data.jpa.repository.JpaRepository;

/**
 * UserRepository repräsentiert ein Interface, welches das Persistieren von Benutzern ermöglicht.
 *
 * @author Nico Harbig
 */
public interface UserRepository extends JpaRepository<User, Long> {
}
