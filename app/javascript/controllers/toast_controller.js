import { Controller } from "@hotwired/stimulus"

/**
 * Toast notification controller
 * Handles the automatic dismissal of toast notifications after a specified duration
 */
export default class extends Controller {
  static values = { duration: Number }
  
  connect() {
    // Set timeout to auto-dismiss based on duration value
    if (this.durationValue > 0) {
      this.timeout = setTimeout(() => {
        this.dismiss()
      }, this.durationValue)
    }
  }
  
  disconnect() {
    // Clear timeout if component is removed
    if (this.timeout) {
      clearTimeout(this.timeout)
    }
  }
  
  dismiss() {
    // Add fade-out effect
    this.element.classList.replace('opacity-100', 'opacity-0')
    
    // Remove element after transition completes
    setTimeout(() => {
      this.element.remove()
    }, 300) // Match with CSS transition duration
  }
}
