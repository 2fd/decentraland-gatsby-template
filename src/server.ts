import { resolve } from "path"

import { databaseInitializer } from "decentraland-gatsby/dist/entities/Database/utils"
import { gatsbyRegister } from "decentraland-gatsby/dist/entities/Prometheus/metrics"
import metrics from "decentraland-gatsby/dist/entities/Prometheus/routes/utils"
import RequestError from "decentraland-gatsby/dist/entities/Route/error"
import handle from "decentraland-gatsby/dist/entities/Route/handle"
import {
  withBody,
  withCors,
  withDDosProtection,
  withLogs,
} from "decentraland-gatsby/dist/entities/Route/middleware"
import { status } from "decentraland-gatsby/dist/entities/Route/routes"
import gatsby from "decentraland-gatsby/dist/entities/Route/routes/filesystem2/gatsby"
import { initializeServices } from "decentraland-gatsby/dist/entities/Server/handler"
import { serverInitializer } from "decentraland-gatsby/dist/entities/Server/utils"
import {
  taskInitializer,
  default as tasksManager,
} from "decentraland-gatsby/dist/entities/Task"
import express from "express"
import { register } from "prom-client"

const tasks = tasksManager()
// tasks.use(CUSTOM_TASK) <--- Add tasks here

const app = express()
app.set("x-powered-by", false)
app.use(withLogs())
app.use("/api", [
  withDDosProtection(),
  withCors(),
  withBody(),
  // <--- Add api handlers here
  status(),
  handle(async () => {
    throw new RequestError("NotFound", RequestError.NotFound)
  }),
])

app.use(metrics([gatsbyRegister, register]))
app.use(
  gatsby(resolve(__filename, "../../public"), {
    contentSecurityPolicy: {
      scriptSrc: [
        "https://decentraland.org",
        "https://*.decentraland.org",
        "https://cdn.segment.com",
        "https://cdn.rollbar.com",
        "https://app.intercom.io",
        "https://widget.intercom.io",
        "https://js.intercomcdn.com",
        "https://verify.walletconnect.com",
      ].join(" "),
    },
  })
)

initializeServices([
  databaseInitializer(),
  taskInitializer(tasks),
  serverInitializer(app, process.env.PORT, process.env.HOST),
])
