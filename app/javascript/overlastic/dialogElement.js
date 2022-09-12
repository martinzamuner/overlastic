export default class DialogElement extends HTMLElement {
  connectedCallback() {
    disableBodyScroll(this)

    this.addEventListener("click", event => this.close(event, true))
    this.querySelector(".overlastic-close").addEventListener("click", event => this.close(event))
  }

  close(event, self = false) {
    if (self && event.target !== this) return

    enableBodyScroll(this)

    // Avoid removing before sending dispatching other events (like form submissions)
    setTimeout(() => {
      this.remove()
    }, 5)
  }
}

customElements.define("overlastic-dialog", DialogElement)
