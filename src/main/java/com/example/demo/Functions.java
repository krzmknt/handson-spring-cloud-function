package com.example.demo;

import com.example.demo.dto.GreetRequest;
import com.example.demo.dto.GreetResponse;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

import java.time.OffsetDateTime;
import java.util.function.Function;
//（SupplierやConsumerも同様に作れます）

@Configuration(proxyBeanMethods = false)
public class Functions {

    // 入力: GreetRequest, 出力: GreetResponse の Function
    @Bean
    public Function<GreetRequest, GreetResponse> greet() {
        return req -> {
            String name = (req != null && req.getName() != null) ? req.getName() : "world";
            return new GreetResponse("Hello, " + name + "!", OffsetDateTime.now().toString());
        };
    }

    // ついでに String -> String のシンプルな関数例（切り替えて使える）
    @Bean
    public Function<String, String> upper() {
        return s -> s == null ? "" : s.toUpperCase();
    }
}
