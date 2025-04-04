import { Controller } from "@hotwired/stimulus"

// Handles the backer checkbox selection UI in fulfillment waves
export default class extends Controller {
  static targets = ["checkbox"]
  
  connect() {
    // Controller initialization
  }
  
  selectAll(event) {
    event.preventDefault()
    this.checkboxTargets.forEach(checkbox => {
      checkbox.checked = true
    })
  }
  
  clearAll(event) {
    event.preventDefault()
    this.checkboxTargets.forEach(checkbox => {
      checkbox.checked = false
    })
  }
}
