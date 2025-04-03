// Import and register all your controllers from the importmap via controllers/**/*_controller
import { application } from "controllers/application"
import { eagerLoadControllersFrom } from "@hotwired/stimulus-loading"
import SliderController from "./slider_controller"
application.register("slider", SliderController)
eagerLoadControllersFrom("controllers", application)
