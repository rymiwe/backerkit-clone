import { Controller } from "@hotwired/stimulus"

// Handles the modal dialog functionality throughout the application with accessibility features
export default class extends Controller {
  static targets = ["dialog"]
  
  connect() {
    // Add event listener for escape key
    this.initialFocus = null
    this.bodyOverflowStyle = document.body.style.overflow
    document.addEventListener("keydown", this.handleKeyDown.bind(this))
  }
  
  disconnect() {
    // Clean up
    document.body.style.overflow = this.bodyOverflowStyle
    document.removeEventListener("keydown", this.handleKeyDown.bind(this))
  }
  
  open(event) {
    // Can be triggered directly or via a button with data-modal-id
    const modalId = event.currentTarget.getAttribute("data-modal-id") || this.element.id
    const modal = document.getElementById(modalId)
    
    if (modal) {
      modal.classList.remove("hidden")
      document.body.style.overflow = "hidden" // Prevent scrolling when modal is open
      
      // Store the current active element to restore focus later
      this.initialFocus = document.activeElement
      
      // Focus the first focusable element in the modal
      setTimeout(() => {
        const focusableElements = this.dialogTarget.querySelectorAll(
          'button, [href], input, select, textarea, [tabindex]:not([tabindex="-1"])'
        )
        if (focusableElements.length > 0) {
          focusableElements[0].focus()
        }
      }, 50)
    }
  }
  
  close() {
    this.element.classList.add("hidden")
    document.body.style.overflow = this.bodyOverflowStyle
    
    // Restore focus to the element that opened the modal
    if (this.initialFocus) {
      this.initialFocus.focus()
    }
  }
  
  handleKeyDown(event) {
    if (event.key === "Escape" && !this.element.classList.contains("hidden")) {
      this.close()
    }
  }
  
  backgroundClick(event) {
    // Close the modal when clicking outside the dialog
    if (this.element === event.target) {
      this.close()
    }
  }
}
