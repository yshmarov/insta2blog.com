import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["source", "trigger"]
  static values = { clicked: String }

  copy(e) {
    e.preventDefault()
    navigator.clipboard.writeText(this.sourceTarget.value)
 
    this.sourceTarget.focus()
    var triggerElement = this.triggerTarget
    var initialHTML = triggerElement.innerHTML
    triggerElement.innerHTML = this.clickedValue
    setTimeout(() => {
      triggerElement.innerHTML = initialHTML
      this.sourceTarget.blur()
    }, 2000)
  }
}