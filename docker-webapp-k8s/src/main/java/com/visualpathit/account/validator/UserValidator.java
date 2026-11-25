package com.visualpathit.account.validator;

import com.visualpathit.account.model.User;
import com.visualpathit.account.service.UserService;

import java.util.regex.Pattern;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.validation.Errors;
import org.springframework.validation.ValidationUtils;
import org.springframework.validation.Validator;

@Component
public class UserValidator implements Validator {

    /** Letters, digits, dot, underscore, hyphen - safe in URLs and HTML. */
    private static final Pattern USERNAME = Pattern.compile("^[A-Za-z0-9._-]+$");
    private static final Pattern EMAIL = Pattern.compile("^[^@\\s]+@[^@\\s]+\\.[^@\\s]+$");

    @Autowired
    private UserService userService;

    @Override
    public boolean supports(Class<?> aClass) {
        return User.class.equals(aClass);
    }

    @Override
    public void validate(Object o, Errors errors) {
        User user = (User) o;

        String username = user.getUsername() == null ? "" : user.getUsername();
        if (username.trim().isEmpty()) {
            errors.rejectValue("username", "NotEmpty");
        } else if (username.length() < 6 || username.length() > 32) {
            errors.rejectValue("username", "Size.userForm.username");
        } else if (!USERNAME.matcher(username).matches()) {
            errors.rejectValue("username", "Pattern.userForm.username");
        } else if (userService.findByUsername(username) != null) {
            errors.rejectValue("username", "Duplicate.userForm.username");
        }

        ValidationUtils.rejectIfEmptyOrWhitespace(errors, "userEmail", "NotEmpty");
        String email = user.getUserEmail();
        if (email != null && !email.trim().isEmpty() && !EMAIL.matcher(email.trim()).matches()) {
            errors.rejectValue("userEmail", "Email.userForm.userEmail");
        }

        String password = user.getPassword() == null ? "" : user.getPassword();
        if (password.isEmpty()) {
            errors.rejectValue("password", "NotEmpty");
        } else if (password.length() < 8 || password.length() > 32) {
            errors.rejectValue("password", "Size.userForm.password");
        }

        if (!password.equals(user.getPasswordConfirm())) {
            errors.rejectValue("passwordConfirm", "Diff.userForm.passwordConfirm");
        }
    }
}
