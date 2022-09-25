// Custom Stream action that allows for finer control of the overlay lifecycle.
//
// Lifecycle events:
//   - overlastic:disconnect right before removing an overlay from the DOM
//   - overlastic:connect right after attaching an overlay to the DOM
//
// Both events target the firstElementChild of the overlastic tag to allow for
// a cleaner listening approach in libraries like Stimulus or Alpine.
//
// The disconnect event is dispatched once for every overlay that will be removed.
// They can be paused and resumed. The new overlay won't be attached until all events
// have been resumed.
Turbo.StreamActions["replaceOverlay"] = function() {
  let overlaysReadyToDisconnect = []
  let callsToResume = 0

  const oldOverlay = this.targetElements[0]
  const overlayName = oldOverlay.id
  const renderNewOverlay = () => {
    callsToResume++

    if (callsToResume >= overlaysReadyToDisconnect.filter(status => status === false).length) {
      Turbo.StreamActions["replace"].bind(this)()

      const newOverlay = document.getElementById(overlayName)
      const connectTarget = newOverlay.firstElementChild || newOverlay
      const connectEvent = new Event("overlastic:connect", { bubbles: true, cancelable: false })

      connectTarget.dispatchEvent(connectEvent)
    }
  }

  overlaysReadyToDisconnect = [oldOverlay, ...oldOverlay.querySelectorAll("overlastic")].map(element => {
    const disconnectTarget = element.firstElementChild || element
    const disconnectEvent =
      new CustomEvent("overlastic:disconnect", { bubbles: true, cancelable: true, detail: { resume: renderNewOverlay } })

    return disconnectTarget.dispatchEvent(disconnectEvent)
  })

  if (overlaysReadyToDisconnect.every(status => status === true)) {
    renderNewOverlay()
  }
}
