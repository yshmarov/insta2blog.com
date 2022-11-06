import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="debounce"
export default class extends Controller {
  static targets = [ "form" ]

  search() {
    clearTimeout(this.timeout)
    this.timeout = setTimeout(() => {
        this.formTarget.requestSubmit()
      }, 400)
  }
}