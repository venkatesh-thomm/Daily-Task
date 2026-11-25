package com.visualpathit.account.controller;

import com.visualpathit.account.model.User;
import com.visualpathit.account.service.ProducerService;
import com.visualpathit.account.service.SecurityService;
import com.visualpathit.account.service.UserService;
import com.visualpathit.account.utils.MemcachedUtils;
import com.visualpathit.account.validator.UserValidator;

import java.security.Principal;
import java.util.List;
import java.util.UUID;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

/** {@author waheedk} */
@Controller
public class UserController {

    /** Username that may open the admin pages (users list, RabbitMQ, Elasticsearch). */
    public static final String ADMIN_USERNAME = "admin_vp";

    private static final Logger LOG = LoggerFactory.getLogger(UserController.class);

    @Autowired
    private UserService userService;

    @Autowired
    private SecurityService securityService;

    @Autowired
    private UserValidator userValidator;

    @Autowired
    private ProducerService producerService;

    /** {@inheritDoc} */
    @RequestMapping(value = "/registration", method = RequestMethod.GET)
    public final String registration(final Model model) {
        model.addAttribute("userForm", new User());
        return "registration";
    }

    /** {@inheritDoc} */
    @RequestMapping(value = "/registration", method = RequestMethod.POST)
    public final String registration(final @ModelAttribute("userForm") User userForm,
                                     final BindingResult bindingResult, final Model model) {
        userValidator.validate(userForm, bindingResult);
        if (bindingResult.hasErrors()) {
            return "registration";
        }
        userService.save(userForm);
        LOG.info("New user registered: {}", userForm.getUsername());

        securityService.autologin(userForm.getUsername(), userForm.getPasswordConfirm());
        return "redirect:/welcome";
    }

    /** {@inheritDoc} */
    @RequestMapping(value = "/login", method = RequestMethod.GET)
    public final String login(final Model model, final String error, final String logout) {
        if (error != null) {
            model.addAttribute("error", "Your username or password is incorrect.");
        }
        if (logout != null) {
            model.addAttribute("message", "You have been signed out.");
        }
        return "login";
    }

    /** Dashboard for the signed-in user. */
    @RequestMapping(value = { "/", "/welcome" }, method = RequestMethod.GET)
    public final String welcome(final Model model, final Principal principal) {
        User user = null;
        if (principal != null && userService != null) {
            user = userService.findByUsername(principal.getName());
        }
        model.addAttribute("user", user);
        model.addAttribute("completion", profileCompletion(user));
        model.addAttribute("podName", podName());
        model.addAttribute("javaVersion", System.getProperty("java.version"));
        return "welcome";
    }

    /** {@inheritDoc} */
    @RequestMapping(value = { "/index" }, method = RequestMethod.GET)
    public final String indexHome(final Model model) {
        return "index_home";
    }

    /** Admin: list all users (URL is restricted in appconfig-security.xml). */
    @RequestMapping(value = "/users", method = RequestMethod.GET)
    public String getAllUsers(final Model model) {
        List<User> users = userService.getList();
        model.addAttribute("users", users);
        return "userList";
    }

    /** Admin: one user's details, served from Memcached when available. */
    @RequestMapping(value = "/users/{id}", method = RequestMethod.GET)
    public String getOneUser(@PathVariable(value = "id") final String id, final Model model) {
        User user = null;
        boolean fromCache = false;
        try {
            long userId = Long.parseLong(id);
            User cached = MemcachedUtils.memcachedGetData(id);
            if (cached != null) {
                user = cached;
                fromCache = true;
            } else {
                user = userService.findById(userId);
                if (user != null) {
                    MemcachedUtils.memcachedSetData(user, id);
                }
            }
        } catch (NumberFormatException e) {
            LOG.warn("Invalid user id requested: {}", id);
        }
        model.addAttribute("user", user);
        model.addAttribute("fromCache", fromCache);
        return "user";
    }

    /** Edit-profile form. Users may only edit themselves (admin may edit anyone). */
    @RequestMapping(value = { "/user/{username:.+}" }, method = RequestMethod.GET)
    public final String userUpdate(@PathVariable(value = "username") final String username,
                                   final Model model, final Principal principal) {
        if (!canEdit(principal, username)) {
            return "redirect:/welcome";
        }
        User user = userService.findByUsername(username);
        if (user == null) {
            return "redirect:/welcome";
        }
        model.addAttribute("user", user);
        return "userUpdate";
    }

    /** Saves the profile. The username is never changed (it is the login identity). */
    @RequestMapping(value = { "/user/{username:.+}" }, method = RequestMethod.POST)
    public final String userUpdateProfile(@PathVariable(value = "username") final String username,
                                          final @ModelAttribute("user") User userForm,
                                          final Model model, final Principal principal) {
        if (!canEdit(principal, username)) {
            return "redirect:/welcome";
        }
        User user = userService.findByUsername(username);
        if (user == null) {
            return "redirect:/welcome";
        }
        user.setUserEmail(userForm.getUserEmail());
        user.setDateOfBirth(userForm.getDateOfBirth());
        user.setFatherName(userForm.getFatherName());
        user.setMotherName(userForm.getMotherName());
        user.setGender(userForm.getGender());
        user.setLanguage(userForm.getLanguage());
        user.setMaritalStatus(userForm.getMaritalStatus());
        user.setNationality(userForm.getNationality());
        user.setPermanentAddress(userForm.getPermanentAddress());
        user.setTempAddress(userForm.getTempAddress());
        user.setPhoneNumber(userForm.getPhoneNumber());
        user.setSecondaryPhoneNumber(userForm.getSecondaryPhoneNumber());
        user.setPrimaryOccupation(userForm.getPrimaryOccupation());
        user.setSecondaryOccupation(userForm.getSecondaryOccupation());
        user.setSkills(userForm.getSkills());
        user.setWorkingExperience(userForm.getWorkingExperience());
        userService.update(user);
        LOG.info("Profile updated: {}", username);

        if (principal.getName().equals(username)) {
            return "redirect:/welcome?updated";
        }
        return "redirect:/users/" + user.getId();
    }

    /** Admin: publishes 20 test messages to RabbitMQ. */
    @RequestMapping(value = { "/user/rabbit" }, method = { RequestMethod.GET })
    public String rabbitmqSetUp() {
        for (int i = 0; i < 20; i++) {
            producerService.produceMessage(generateString());
        }
        return "rabbitmq";
    }

    private static String generateString() {
        return "uuid = " + UUID.randomUUID().toString();
    }

    private static boolean canEdit(final Principal principal, final String username) {
        if (principal == null || username == null) {
            return false;
        }
        return principal.getName().equals(username) || ADMIN_USERNAME.equals(principal.getName());
    }

    /** Pod name in Kubernetes, container ID in Docker, "local" otherwise. */
    private static String podName() {
        String host = System.getenv("HOSTNAME");
        return (host == null || host.isEmpty()) ? "local" : host;
    }

    /** Percentage of optional profile fields the user has filled in. */
    static int profileCompletion(final User user) {
        if (user == null) {
            return 0;
        }
        String[] fields = {
            user.getUserEmail(), user.getDateOfBirth(), user.getFatherName(), user.getMotherName(),
            user.getGender(), user.getMaritalStatus(), user.getPermanentAddress(), user.getTempAddress(),
            user.getPrimaryOccupation(), user.getSecondaryOccupation(), user.getSkills(),
            user.getPhoneNumber(), user.getSecondaryPhoneNumber(), user.getNationality(),
            user.getLanguage(), user.getWorkingExperience(), user.getProfileImg()
        };
        int filled = 0;
        for (String f : fields) {
            if (f != null && !f.trim().isEmpty()) {
                filled++;
            }
        }
        return Math.round(filled * 100f / fields.length);
    }
}
