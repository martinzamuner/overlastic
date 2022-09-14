// Save the clicked overlay link element for use down the line
addEventListener("click", event => {
  window._overlasticAnchor = event.target.closest("a[data-turbo-frame^=overlay]")
})

// Send overlay type and args along with the frame request
addEventListener("turbo:before-fetch-request", event => {
  if (!window._overlasticAnchor) return

  const anchor = window._overlasticAnchor
  const type = anchor?.dataset?.overlayType
  const target = anchor?.dataset?.overlayTarget
  const args = anchor?.dataset?.overlayArgs

  if (type) {
    event.detail.fetchOptions.headers["Overlay-Type"] = type
  }

  if (target) {
    event.detail.fetchOptions.headers["Overlay-Target"] = target
  }

  if (args) {
    event.detail.fetchOptions.headers["Overlay-Args"] = args
  }

  delete window._overlasticTarget
})
