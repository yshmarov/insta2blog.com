import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="clipboard"
// export default class extends Controller {
//   static targets = [ "source" ]

//   copy() {
//     navigator.clipboard.writeText(this.sourceTarget.value)
//     this.sourceTarget.focus()
//   }
// }

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