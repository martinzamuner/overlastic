// Save the clicked overlay link element for use down the line.
addEventListener("click", event => {
  window._overlasticAnchor = event.target.closest("a[data-turbo-frame^=overlay]")
}, true)

// In order to respect frame behavior, overlay stream responses replace whole frames and
// come with the correct src. This triggers the frame controller to attempt an eager load.
// We don't want that for overlays, so we cancel those requests.
addEventListener("turbo:before-fetch-request", event => {
  if (!event.target.hasAttribute("cancel")) return

  event.preventDefault()

  event.target.removeAttribute("cancel")
}, true)

// Allow progressive enhancement by telling the server if a request is handled by Turbo.
addEventListener("turbo:before-fetch-request", event => {
  event.detail.fetchOptions.headers["Overlay-Enabled"] = "1"
})

// When an overlay anchor is clicked,
// send its type, target and args along with the frame request.
addEventListener("turbo:before-fetch-request", event => {
  if (!window._overlasticAnchor) return

  const anchor = window._overlasticAnchor
  const type = anchor?.dataset?.overlayType
  const target = anchor?.dataset?.overlayTarget
  const args = anchor?.dataset?.overlayArgs

  event.detail.fetchOptions.headers["Overlay-Initiator"] = "1"

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

// When any other element triggers a fetch,
// send the current overlay's target along with the frame request.
addEventListener("turbo:before-fetch-request", event => {
  if (window._overlasticAnchor) return

  const frame = event.target.closest("turbo-frame[id^=overlay]")

  if (frame) {
    const target = frame.dataset.overlayTarget
    const initiator = frame.dataset?.overlayInitiator
    const type = frame.dataset?.overlayType
    const args = frame.dataset?.overlayArgs

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
})

// Handle frame-to-visit promotions when the server asks for it.
addEventListener("turbo:before-fetch-response", async event => {
  const fetchResponse = event.detail.fetchResponse
  const visit = fetchResponse.response.headers.get("Overlay-Visit")

  if (!visit) return

  const responseHTML = await fetchResponse.responseHTML
  const { redirected, statusCode } = fetchResponse

  return Turbo.session.visit(visit, { shouldCacheSnapshot: false, response: { redirected, statusCode, responseHTML } })
})
