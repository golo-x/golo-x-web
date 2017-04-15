module demo

import vert.x.helpers
import web.extensions
import JSON

import gololang.Errors

function main = |args| {

  println("🤖 initializing...")
  let httpPort = 9090
  let server = createHttpServer()
  let router = getRouter()

  # try this in the navigatoe console:
  #
  #  fetch("/hello", {
  #    method: 'post',
  #    headers: {
  #      'Content-Type': 'application/json'
  #    },
  #    body: JSON.stringify({
  #      firstName: "Bob",
  #      lastName: "Morane",
  #      avatar: "🐼"
  #    })
  #  })
  #  .then(res => res.json())
  #  .then(res => console.log(res))
  router: post("/hello", |context| {
    trying({
      let who = context: dbody()
      println(
        who: firstName() + " " +
        who: lastName() + " aka " +
        who: avatar() + " ❤️ Vert-x"
      )
      return who
    })
    : either(
      recover = |error| {
        println("error: " + error: message())
        context: response(): djson(): error(error: message()): send()
      },
      mapping = |who| ->
        context: response(): djson(): message("😄 Roger"+ who: avatar() +"!"): send()
    )

  })

  # try this in the navigatoe console:
  # fetch("/hello/bob").then(data => {return data.json();}).then(data => { console.log(data);})
  router: get("/hello/:who", |context| {
    trying({
      return context: request(): param("who")
    })
    : either(
      recover = |error| {
        println("error: " + error: message())
        context: response(): djson(): error(error: message()): send()
      },
      mapping = |name| ->
        context: response(): djson(): message("Hello"): who(name): send()
    )
  })

  startHttpServer(
    server=server,
    router=router,
    port=httpPort,
    staticPath="/*"
  )

}
