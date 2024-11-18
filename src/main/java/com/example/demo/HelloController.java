package com.example.demo;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.stereotype.Controller;

@Controller
public class HelloController {

    @GetMapping("/")
    public String sayHello() {
        return "index.html";
    }
    @GetMapping("/live")
    public String liveCheck() {
        // This is a simple response. You can customize it as needed.
        return "Application is live";
    }

}