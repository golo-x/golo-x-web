module web.extensions

import JSON

augment io.vertx.ext.web.Router {
  function get = |this, uri, handler| {
    return this: get(uri): handler(handler)
  }
  function post = |this, uri, handler| {
    return this: post(uri): handler(handler)
  }
}

augment io.vertx.core.http.HttpServerResponse {
  function json = |this, content| ->
    this: putHeader("content-type", "application/json;charset=UTF-8")
        : end(JSON.stringify(content), "UTF-8")

  function djson = |this| {
    this: putHeader("content-type", "application/json;charset=UTF-8")
    let d = DynamicObject()
    d: define("send", |self| {
        this: end(JSON.stringify(self), "UTF-8")
      })
    return d
  }

  function html = |this, content| ->
    this: putHeader("content-type", "text/html;charset=UTF-8")
        : end(content, "UTF-8")

  function text = |this, content| ->
    this: putHeader("content-type", "text/plain;charset=UTF-8")
        : end(content, "UTF-8")
}

augment io.vertx.core.http.HttpServerRequest {
  function param = |this, paramName| -> this: getParam(paramName)
}

augment io.vertx.ext.web.RoutingContext {
  function bodyAsJson = |this| ->
    JSON.parse(this: getBodyAsString())

  function dbody = |this| ->
    JSON.toDynamicObjectTreeFromString(this: getBodyAsString())
}
# JSON.parse(this: getBodyAsString())
