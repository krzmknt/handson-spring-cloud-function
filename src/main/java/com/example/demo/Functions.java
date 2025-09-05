package com.example.demo;

import java.time.OffsetDateTime;
import java.util.function.Function;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import com.example.demo.dto.GreetRequest;
import com.example.demo.dto.GreetResponse;

/**
 *
 */
@Configuration(proxyBeanMethods = false)
public class Functions {

    private static final Logger logger = LoggerFactory.getLogger(Functions.class);

    @Bean
    public Function<GreetRequest, GreetResponse> greet() {
        return req -> {
            logger.info("🚀 greet function called with request: {}", req);
            String name = (req != null && req.getName() != null) ? req.getName() : "world";
            logger.debug("🚀 Processing greeting for name: {}", name);

            GreetResponse response = new GreetResponse("Hello, " + name + "!", OffsetDateTime.now().toString());
            logger.info("🚀 greet function returning response: {}", response);

            return response;
        };
    }

    @Bean
    public Function<String, String> upper() {
        return s -> {
            logger.info("🦄 upper function called with input: {}", s);
            String result = s == null ? "" : s.toUpperCase();
            logger.info("🦄 upper function returning: {}", result);
            return result;
        };
    }
}
