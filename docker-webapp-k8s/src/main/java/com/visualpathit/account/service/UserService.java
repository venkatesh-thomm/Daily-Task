package com.visualpathit.account.service;

import java.util.List;

import com.visualpathit.account.model.User;

/** {@author waheedk}!*/
public interface UserService {
    /** Registers a NEW user: hashes the raw password and assigns roles. */
    void save(User user);

    /** Saves changes to an EXISTING user without touching the password hash. */
    void update(User user);

    /** {@inheritDoc}} !*/
    User findByUsername(String username);

    User findById(long id);

    List<User> getList();
}
