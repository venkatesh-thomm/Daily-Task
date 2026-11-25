package com.visualpathit.account.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

/**
 * Lightweight health endpoint for Kubernetes probes and the AWS ALB health check.
 * Public, creates no HTTP session and does not touch the database, so a slow DB
 * never makes Kubernetes restart healthy Tomcat pods.
 */
@Controller
public class HealthController {

    @RequestMapping(value = "/health", method = { RequestMethod.GET, RequestMethod.HEAD })
    @ResponseBody
    public String health() {
        return "OK";
    }
}
