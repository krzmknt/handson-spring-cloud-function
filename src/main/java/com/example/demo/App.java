package com.example.demo;

import org.springframework.boot.autoconfigure.SpringBootApplication;

/**
 * FunctionInvoker が起動時に拾うだけ。main不要
 **/
@SpringBootApplication(proxyBeanMethods = false)
public class App {
}
