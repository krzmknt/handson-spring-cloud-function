package com.example.demo;

import java.time.OffsetDateTime;
import java.util.function.Function;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import com.example.demo.dto.GreetRequest;
import com.example.demo.dto.GreetResponse;

/**
 *
 */
@Configuration(proxyBeanMethods = false)
public class Functions {

    /**
     * 挨拶関数
     *
     * GreetRequestを受け取り、GreetResponseを返す
     */
    @Bean
    public Function<GreetRequest, GreetResponse> greet() {
        return req -> {
            String name = (req != null && req.getName() != null) ? req.getName() : "world";
            return new GreetResponse("Hello, " + name + "!", OffsetDateTime.now().toString());
        };
    }

    /**
     * アッパーケース関数
     *
     * 文字列を大文字に変換する
     */
    @Bean
    public Function<String, String> upper() {
        return s -> s == null ? "" : s.toUpperCase();
    }
}
