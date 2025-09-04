FROM public.ecr.aws/lambda/java:21
COPY target/*-shaded.jar /var/task/lib/app.jar
CMD ["org.springframework.cloud.function.adapter.aws.FunctionInvoker::handleRequest"]

