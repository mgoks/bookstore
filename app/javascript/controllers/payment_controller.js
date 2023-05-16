import {Controller} from "@hotwired/stimulus"

// Connects to data-controller="payment"
export default class extends Controller {
  static targets = [ "selection", "additionalFields" ]

  initialize() { this.showAdditionalFields() }

  showAdditionalFields() {
    let selection = this.selectionTarget.value
    for (let fields of this.additionalFieldsTargets) {
      if (fields.dataset.type == selection) {
        fields.disabled = fields.hidden = false;
      } else {
        fields.disabled = fields.hidden = true;
      }
    }
  }
}
