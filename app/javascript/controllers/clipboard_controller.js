import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["source", "trigger"]

  copy(e) {
    e.preventDefault()
    navigator.clipboard.writeText(this.sourceTarget.value)
 
    this.sourceTarget.focus()
    var triggerElement = this.triggerTarget
    var initialHTML = triggerElement.innerHTML
    triggerElement.innerHTML = "<i class='fa-regular fa-circle-check text-green-600'></i>"
    setTimeout(() => {
      triggerElement.innerHTML = initialHTML
      this.sourceTarget.blur()
    }, 2000)
  }
}