// Save the clicked overlay link element for use down the line
addEventListener("click", event => {
  window._overlasticClickedElement = event.target.closest("[data-turbo-frame^=overlay]")
})

// Set the correct target for the frame according to the desired behavior
addEventListener("click", _event => {
  if (!window._overlasticClickedElement) return

  const target = window._overlasticClickedElement.dataset.overlayTarget
  const frame = document.querySelector(`turbo-frame#${window._overlasticClickedElement.dataset.turboFrame}`)

  if (target === "_self") {
    frame.removeAttribute("target")
  } else {
    frame.setAttribute("target", "_top")
  }
})

// Send overlay type and args along with the frame request
addEventListener("turbo:before-fetch-request", event => {
  if (!window._overlasticClickedElement) return

  const target = window._overlasticClickedElement
  const type = target?.dataset?.overlayType
  const args = target?.dataset?.overlayArgs

  if (type) {
    event.detail.fetchOptions.headers["Overlay-Type"] = type
  }

  if (args) {
    event.detail.fetchOptions.headers["Overlay-Args"] = args
  }

  delete window._overlasticTarget
})
