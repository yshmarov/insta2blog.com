import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="form-reset"
export default class extends Controller {
  connect() {
    this.element.reset()
  }
}
