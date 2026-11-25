package com.visualpathit.account.controller;

import java.io.File;
import java.io.IOException;
import java.nio.file.Files;
import java.security.Principal;

import javax.servlet.http.HttpServletResponse;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;

import com.visualpathit.account.model.User;
import com.visualpathit.account.service.UserService;

/**
 * Profile photo upload and download.
 * The owner is always the signed-in user; file names are generated server-side
 * and the content is checked to really be an image.
 */
@Controller
public class FileUploadController {

    private static final Logger LOG = LoggerFactory.getLogger(FileUploadController.class);

    @Autowired
    private UserService userService;

    @RequestMapping(value = { "/upload" }, method = RequestMethod.GET)
    public final String upload(final Model model) {
        return "upload";
    }

    @RequestMapping(value = "/uploadFile", method = RequestMethod.POST)
    public String uploadFileHandler(@RequestParam("file") final MultipartFile file,
                                    final Principal principal, final Model model) {
        if (principal == null) {
            return "redirect:/login";
        }
        if (file == null || file.isEmpty()) {
            model.addAttribute("error", "Please choose an image to upload.");
            return "upload";
        }
        User user = userService.findByUsername(principal.getName());
        if (user == null) {
            return "redirect:/login";
        }
        try {
            byte[] bytes = file.getBytes();
            String ext = detectImageType(bytes);
            if (ext == null) {
                model.addAttribute("error", "Only PNG, JPG, GIF or WebP images are allowed.");
                return "upload";
            }
            File dir = uploadDir();
            if (!dir.isDirectory() && !dir.mkdirs()) {
                throw new IOException("Cannot create upload directory " + dir);
            }
            String fileName = "user-" + user.getId() + "." + ext;
            File target = new File(dir, fileName);
            Files.write(target.toPath(), bytes);

            // remove a previous photo with a different extension
            String old = user.getProfileImg();
            if (old != null && !old.equals(fileName) && old.matches("user-\\d+\\.[a-z]+")) {
                Files.deleteIfExists(new File(dir, old).toPath());
            }

            user.setProfileImg(fileName);
            user.setProfileImgPath(target.getAbsolutePath());
            userService.update(user);
            LOG.info("Profile photo updated for {} ({} bytes)", user.getUsername(), bytes.length);
            return "redirect:/welcome?photo";
        } catch (IOException e) {
            LOG.error("Photo upload failed for {}", principal.getName(), e);
            model.addAttribute("error", "Upload failed. Please try again.");
            return "upload";
        }
    }

    /** Streams a user's profile photo (signed-in users only, see appconfig-security.xml). */
    @RequestMapping(value = "/profile/photo/{username:.+}", method = RequestMethod.GET)
    public void photo(@PathVariable("username") final String username,
                      final HttpServletResponse response) throws IOException {
        User user = userService.findByUsername(username);
        String name = (user == null) ? null : user.getProfileImg();
        if (name == null || !name.matches("user-\\d+\\.(png|jpg|gif|webp)")) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
            return;
        }
        File f = new File(uploadDir(), name);
        if (!f.isFile()) {
            // photo lives on another pod's local disk, or the pod restarted
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
            return;
        }
        String ext = name.substring(name.lastIndexOf('.') + 1);
        response.setContentType("jpg".equals(ext) ? "image/jpeg" : "image/" + ext);
        response.setHeader("Cache-Control", "private, max-age=300");
        response.setContentLength((int) f.length());
        Files.copy(f.toPath(), response.getOutputStream());
    }

    /** UPLOAD_DIR env var (e.g. a mounted volume), else $CATALINA_HOME/tmpFiles. */
    static File uploadDir() {
        String dir = System.getenv("UPLOAD_DIR");
        if (dir == null || dir.isEmpty()) {
            dir = System.getProperty("catalina.home", System.getProperty("java.io.tmpdir")) + File.separator + "tmpFiles";
        }
        return new File(dir);
    }

    /** Returns the file extension for PNG/JPEG/GIF/WebP content, or null for anything else. */
    static String detectImageType(final byte[] b) {
        if (b == null || b.length < 12) {
            return null;
        }
        if ((b[0] & 0xFF) == 0x89 && b[1] == 'P' && b[2] == 'N' && b[3] == 'G') {
            return "png";
        }
        if ((b[0] & 0xFF) == 0xFF && (b[1] & 0xFF) == 0xD8 && (b[2] & 0xFF) == 0xFF) {
            return "jpg";
        }
        if (b[0] == 'G' && b[1] == 'I' && b[2] == 'F' && b[3] == '8') {
            return "gif";
        }
        if (b[0] == 'R' && b[1] == 'I' && b[2] == 'F' && b[3] == 'F'
                && b[8] == 'W' && b[9] == 'E' && b[10] == 'B' && b[11] == 'P') {
            return "webp";
        }
        return null;
    }
}
