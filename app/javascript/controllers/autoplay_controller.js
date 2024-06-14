import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="video"
export default class extends Controller {
  static targets = ['player', 'next']

  connect() {
    const link = this.nextTarget
    this.playerTarget.onended = function() {
      link.click()
    };
  }
}
