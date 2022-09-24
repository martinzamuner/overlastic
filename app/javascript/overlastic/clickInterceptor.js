// Save the clicked element for use down the line.
addEventListener("click", event => {
  window._overlasticInitiator = event.target
}, true)

// Overlay anchors come with target _blank to serve as fallback in case JS is not enabled.
addEventListener("click", _event => {
  const anchor = window._overlasticInitiator?.closest("a[data-overlay-name]")

  if (anchor) {
    anchor.removeAttribute("target")
  }
}, true)

// Allow progressive enhancement by telling the server if a request is handled by Turbo.
addEventListener("turbo:before-fetch-request", event => {
    event.detail.fetchOptions.headers["Overlay-Enabled"] = "1"
})

// When an overlay anchor is clicked,
// send its type, target and args along with the visit request.
addEventListener("turbo:before-fetch-request", event => {
  const anchor = window._overlasticInitiator?.closest("a[data-overlay-name]")
  const name = anchor?.dataset?.overlayName
  const type = anchor?.dataset?.overlayType
  const target = anchor?.dataset?.overlayTarget
  const args = anchor?.dataset?.overlayArgs

  if (anchor) {
    event.detail.fetchOptions.headers["Overlay-Initiator"] = "1"
    event.detail.fetchOptions.headers["Overlay-Name"] = name

    if (type) {
      event.detail.fetchOptions.headers["Overlay-Type"] = type
    }

    if (target) {
      event.detail.fetchOptions.headers["Overlay-Target"] = target
    }

    if (args) {
      event.detail.fetchOptions.headers["Overlay-Args"] = args
    }
  }
})

// When the redirect script triggers a fetch,
// send the current overlay's target along with the visit request.
addEventListener("turbo:before-fetch-request", event => {
  const script = document.querySelector("script[overlay]")

  if (script) {
    const overlay = document.querySelector(`overlastic[id=${script.getAttribute("overlay")}]`)

    if (overlay) {
      const name = overlay.id
      const target = overlay.dataset.overlayTarget
      const type = overlay.dataset?.overlayType
      const args = overlay.dataset?.overlayArgs

      event.detail.fetchOptions.headers["Overlay-Name"] = name
      event.detail.fetchOptions.headers["Overlay-Target"] = target
      event.detail.fetchOptions.headers["Overlay-Initiator"] = "1"

      if (type) {
        event.detail.fetchOptions.headers["Overlay-Type"] = type
      }

      if (args) {
        event.detail.fetchOptions.headers["Overlay-Args"] = args
      }
    }
  }
})

// When any other element triggers a fetch,
// send the current overlay's target along with the visit request.
addEventListener("turbo:before-fetch-request", event => {
  const initiator = window._overlasticInitiator?.closest("a, form")
  const overlay = initiator?.closest("overlastic")

  if (overlay && !initiator.dataset.overlay && !initiator.dataset.overlayName) {
    const name = overlay.id
    const target = overlay.dataset.overlayTarget
    const initiator = overlay.dataset?.overlayInitiator
    const type = overlay.dataset?.overlayType
    const args = overlay.dataset?.overlayArgs

    event.detail.fetchOptions.headers["Overlay-Name"] = name
    event.detail.fetchOptions.headers["Overlay-Target"] = target

    if (initiator) {
      event.detail.fetchOptions.headers["Overlay-Initiator"] = initiator
    }

    if (type) {
      event.detail.fetchOptions.headers["Overlay-Type"] = type
    }

    if (args) {
      event.detail.fetchOptions.headers["Overlay-Args"] = args
    }
  }

  delete window._overlasticInitiator
})
