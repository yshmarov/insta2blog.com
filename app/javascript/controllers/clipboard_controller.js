import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["source", "trigger"]

  copy(e) {
    e.preventDefault()
    navigator.clipboard.writeText(this.sourceTarget.value)
 
    this.sourceTarget.focus()
    var triggerElement = this.triggerTarget
    var initialHTML = triggerElement.innerHTML
    triggerElement.innerHTML = "<span>Copied</span>"
    setTimeout(() => {
      triggerElement.innerHTML = initialHTML
    }, 2000)
  }
}