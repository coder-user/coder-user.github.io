# 【jaeger】最简单的jaeger测试环境部署教程

jaeger: open source, end-to-end distributed tracing Monitor and troubleshoot transactions in complex distributed systems..

<!--more-->

## 简述

​	Jaeger: open source, end-to-end distributed tracing Monitor and troubleshoot transactions in complex distributed systems

### Why Jaeger?

​	As on-the-ground microservice practitioners are quickly realizing, the majority of operational problems that arise when moving to a distributed architecture are ultimately grounded in two areas: **networking** and **observability**. It is simply an orders of magnitude larger problem to network and debug a set of intertwined distributed services versus a single monolithic application.

## 部署说明

> [Jaeger官网入门指南](https://www.jaegertracing.io/docs/1.21/getting-started/)

### All in One

All-in-one is an executable designed for quick local testing, launches the Jaeger UI, collector, query, and agent, with an in memory storage component.

The simplest way to start the all-in-one is to use the pre-built image published to DockerHub (a single command line).

```bash
$ docker run -d --name jaeger \
  -e COLLECTOR_ZIPKIN_HTTP_PORT=9411 \
  -p 5775:5775/udp \
  -p 6831:6831/udp \
  -p 6832:6832/udp \
  -p 5778:5778 \
  -p 16686:16686 \
  -p 14268:14268 \
  -p 14250:14250 \
  -p 9411:9411 \
  jaegertracing/all-in-one:1.21
```

- 使用docker部署，jaeger测试的所有服务.

| Port  | Protocol | Component | Function                                                     |
| :---- | :------- | :-------- | :----------------------------------------------------------- |
| 5775  | UDP      | agent     | accept `zipkin.thrift` over compact thrift protocol (deprecated, used by legacy clients only) |
| 6831  | UDP      | agent     | accept `jaeger.thrift` over compact thrift protocol          |
| 6832  | UDP      | agent     | accept `jaeger.thrift` over binary thrift protocol           |
| 5778  | HTTP     | agent     | serve configs                                                |
| 16686 | HTTP     | query     | serve frontend                                               |
| 14268 | HTTP     | collector | accept `jaeger.thrift` directly from clients                 |
| 14250 | HTTP     | collector | accept `model.proto`                                         |
| 9411  | HTTP     | collector | Zipkin compatible endpoint (optional)                        |

## 总结

​	docker方式部署开源服务，使得部署变得尤为的简单，这边也是简单的说明一个docker部署的例子，为之前学习的Docker知识做一个实践.
