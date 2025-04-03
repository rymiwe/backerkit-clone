import { Controller } from "@hotwired/stimulus"

// Handles a slider for updating fulfillment progress
export default class extends Controller {
  static targets = ["input", "valueDisplay", "saveButton", "sliderContainer"]
  static values = { 
    project: String,
    reward: String,
    status: String
  }
  
  connect() {
    this.saveButtonTarget.disabled = true
    this.originalValue = this.inputTarget.value
    
    // Set initial fill percentage based on the current value
    this.updateFillPercentage(this.inputTarget.value)
  }
  
  updateProgress(event) {
    const value = event.target.value
    this.valueDisplayTarget.textContent = `${value}%`
    
    // Update the fill percentage
    this.updateFillPercentage(value)
    
    // Enable save button only if value has changed
    this.saveButtonTarget.disabled = (value == this.originalValue)
  }
  
  updateFillPercentage(value) {
    // Update the CSS variable that controls the fill width
    this.sliderContainerTarget.style.setProperty('--fill-percentage', `${value}%`)
  }
}
