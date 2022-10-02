addEventListener("click", (event => {
  window._overlasticInitiator = event.target;
}), true);

addEventListener("click", (_event => {
  const anchor = window._overlasticInitiator?.closest("a[data-overlay-name]");
  if (anchor) {
    anchor.removeAttribute("target");
  }
}), true);

addEventListener("turbo:before-fetch-request", (event => {
  event.detail.fetchOptions.headers["Overlay-Enabled"] = "1";
}));

addEventListener("turbo:before-fetch-request", (event => {
  const anchor = window._overlasticInitiator?.closest("a[data-overlay-name]");
  const name = anchor?.dataset?.overlayName;
  const type = anchor?.dataset?.overlayType;
  const target = anchor?.dataset?.overlayTarget;
  const args = anchor?.dataset?.overlayArgs;
  if (anchor) {
    event.detail.fetchOptions.headers["Overlay-Initiator"] = "1";
    event.detail.fetchOptions.headers["Overlay-Name"] = name;
    if (type) {
      event.detail.fetchOptions.headers["Overlay-Type"] = type;
    }
    if (target) {
      event.detail.fetchOptions.headers["Overlay-Target"] = target;
    }
    if (args) {
      event.detail.fetchOptions.headers["Overlay-Args"] = args;
    }
  }
}));

addEventListener("turbo:before-fetch-request", (event => {
  const script = document.querySelector("script[overlay]");
  if (script) {
    const overlay = document.querySelector(`overlastic[id=${script.getAttribute("overlay")}]`);
    if (overlay) {
      const name = overlay.id;
      const target = overlay.dataset.overlayTarget;
      const type = overlay.dataset?.overlayType;
      const args = overlay.dataset?.overlayArgs;
      event.detail.fetchOptions.headers["Overlay-Name"] = name;
      event.detail.fetchOptions.headers["Overlay-Target"] = target;
      event.detail.fetchOptions.headers["Overlay-Initiator"] = "1";
      if (type) {
        event.detail.fetchOptions.headers["Overlay-Type"] = type;
      }
      if (args) {
        event.detail.fetchOptions.headers["Overlay-Args"] = args;
      }
    }
  }
}));

addEventListener("turbo:before-fetch-request", (event => {
  const initiator = window._overlasticInitiator?.closest("a, form");
  const overlay = initiator?.closest("overlastic");
  if (overlay && !initiator.dataset.overlay && !initiator.dataset.overlayName) {
    const name = overlay.id;
    const target = overlay.dataset.overlayTarget;
    const initiator = overlay.dataset?.overlayInitiator;
    const type = overlay.dataset?.overlayType;
    const args = overlay.dataset?.overlayArgs;
    event.detail.fetchOptions.headers["Overlay-Name"] = name;
    event.detail.fetchOptions.headers["Overlay-Target"] = target;
    if (initiator) {
      event.detail.fetchOptions.headers["Overlay-Initiator"] = initiator;
    }
    if (type) {
      event.detail.fetchOptions.headers["Overlay-Type"] = type;
    }
    if (args) {
      event.detail.fetchOptions.headers["Overlay-Args"] = args;
    }
  }
  delete window._overlasticInitiator;
}));

Turbo.StreamActions["replaceOverlay"] = function() {
  let overlaysReadyToDisconnect = [];
  let callsToResume = 0;
  const oldOverlay = this.targetElements[0];
  const overlayName = oldOverlay.id;
  const renderNewOverlay = () => {
    callsToResume++;
    if (callsToResume >= overlaysReadyToDisconnect.filter((status => status === false)).length) {
      Turbo.StreamActions["replace"].bind(this)();
      const newOverlay = document.getElementById(overlayName);
      const connectTarget = newOverlay.firstElementChild || newOverlay;
      const connectEvent = new Event("overlastic:connect", {
        bubbles: true,
        cancelable: false
      });
      connectTarget.dispatchEvent(connectEvent);
    }
  };
  overlaysReadyToDisconnect = [ oldOverlay, ...oldOverlay.querySelectorAll("overlastic") ].map((element => {
    const disconnectTarget = element.firstElementChild || element;
    const disconnectEvent = new CustomEvent("overlastic:disconnect", {
      bubbles: true,
      cancelable: true,
      detail: {
        resume: renderNewOverlay
      }
    });
    return disconnectTarget.dispatchEvent(disconnectEvent);
  }));
  if (overlaysReadyToDisconnect.every((status => status === true))) {
    renderNewOverlay();
  }
};
