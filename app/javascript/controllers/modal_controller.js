import { Controller } from "@hotwired/stimulus"

// Handles the modal dialog functionality for the fulfillment updates
export default class extends Controller {
  connect() {
    // Add event listener for escape key
    document.addEventListener("keydown", this.handleKeyDown.bind(this))
  }
  
  disconnect() {
    // Clean up event listener
    document.removeEventListener("keydown", this.handleKeyDown.bind(this))
  }
  
  open(event) {
    const modalId = event.currentTarget.getAttribute("data-modal-target")
    const modal = document.getElementById(modalId)
    
    if (modal) {
      modal.classList.remove("hidden")
      document.body.classList.add("overflow-hidden") // Prevent scrolling when modal is open
    }
  }
  
  close() {
    this.element.classList.add("hidden")
    document.body.classList.remove("overflow-hidden")
  }
  
  handleKeyDown(event) {
    if (event.key === "Escape" && !this.element.classList.contains("hidden")) {
      this.close()
    }
  }
}
