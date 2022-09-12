addEventListener("click", event => {
  window._overlasticTarget = event.target.closest("[data-turbo-frame*=overlay]")
})

addEventListener("turbo:before-fetch-request", event => {
  if (!window._overlasticTarget) return

  const target = window._overlasticTarget
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
