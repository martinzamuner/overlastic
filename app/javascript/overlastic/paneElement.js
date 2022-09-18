import DialogElement from "./dialogElement"

class PaneElement extends DialogElement {
  connectedCallback() {
    super.connectedCallback()

    const lastVisit = Turbo.navigator.history.location

    if (!window.modalVisitStack) {
      window.modalVisitStack = []
    }

    window.modalVisitStack.push(lastVisit)
    Turbo.navigator.history.push(new URL(this.parentElement.getAttribute("src")))
  }

  close(event, self = false) {
    if (self && event.target !== this) return

    super.close(event, self)

    if (window.modalVisitStack.length > 0) {
      Turbo.navigator.history.replace(window.modalVisitStack.pop())
    }
  }
}

customElements.define("overlastic-pane", PaneElement)
