function _toConsumableArray(arr) {
  if (Array.isArray(arr)) {
    for (var i = 0, arr2 = Array(arr.length); i < arr.length; i++) {
      arr2[i] = arr[i];
    }
    return arr2;
  } else {
    return Array.from(arr);
  }
}

var hasPassiveEvents = false;

if (typeof window !== "undefined") {
  var passiveTestOptions = {
    get passive() {
      hasPassiveEvents = true;
      return undefined;
    }
  };
  window.addEventListener("testPassive", null, passiveTestOptions);
  window.removeEventListener("testPassive", null, passiveTestOptions);
}

var isIosDevice = typeof window !== "undefined" && window.navigator && window.navigator.platform && (/iP(ad|hone|od)/.test(window.navigator.platform) || window.navigator.platform === "MacIntel" && window.navigator.maxTouchPoints > 1);

var locks = [];

var documentListenerAdded = false;

var initialClientY = -1;

var previousBodyOverflowSetting = void 0;

var previousBodyPosition = void 0;

var previousBodyPaddingRight = void 0;

var allowTouchMove = function allowTouchMove(el) {
  return locks.some((function(lock) {
    if (lock.options.allowTouchMove && lock.options.allowTouchMove(el)) {
      return true;
    }
    return false;
  }));
};

var preventDefault = function preventDefault(rawEvent) {
  var e = rawEvent || window.event;
  if (allowTouchMove(e.target)) {
    return true;
  }
  if (e.touches.length > 1) return true;
  if (e.preventDefault) e.preventDefault();
  return false;
};

var setOverflowHidden = function setOverflowHidden(options) {
  if (previousBodyPaddingRight === undefined) {
    var _reserveScrollBarGap = !!options && options.reserveScrollBarGap === true;
    var scrollBarGap = window.innerWidth - document.documentElement.clientWidth;
    if (_reserveScrollBarGap && scrollBarGap > 0) {
      var computedBodyPaddingRight = parseInt(window.getComputedStyle(document.body).getPropertyValue("padding-right"), 10);
      previousBodyPaddingRight = document.body.style.paddingRight;
      document.body.style.paddingRight = computedBodyPaddingRight + scrollBarGap + "px";
    }
  }
  if (previousBodyOverflowSetting === undefined) {
    previousBodyOverflowSetting = document.body.style.overflow;
    document.body.style.overflow = "hidden";
  }
};

var restoreOverflowSetting = function restoreOverflowSetting() {
  if (previousBodyPaddingRight !== undefined) {
    document.body.style.paddingRight = previousBodyPaddingRight;
    previousBodyPaddingRight = undefined;
  }
  if (previousBodyOverflowSetting !== undefined) {
    document.body.style.overflow = previousBodyOverflowSetting;
    previousBodyOverflowSetting = undefined;
  }
};

var setPositionFixed = function setPositionFixed() {
  return window.requestAnimationFrame((function() {
    if (previousBodyPosition === undefined) {
      previousBodyPosition = {
        position: document.body.style.position,
        top: document.body.style.top,
        left: document.body.style.left
      };
      var _window = window, scrollY = _window.scrollY, scrollX = _window.scrollX, innerHeight = _window.innerHeight;
      document.body.style.position = "fixed";
      document.body.style.top = -scrollY;
      document.body.style.left = -scrollX;
      setTimeout((function() {
        return window.requestAnimationFrame((function() {
          var bottomBarHeight = innerHeight - window.innerHeight;
          if (bottomBarHeight && scrollY >= innerHeight) {
            document.body.style.top = -(scrollY + bottomBarHeight);
          }
        }));
      }), 300);
    }
  }));
};

var restorePositionSetting = function restorePositionSetting() {
  if (previousBodyPosition !== undefined) {
    var y = -parseInt(document.body.style.top, 10);
    var x = -parseInt(document.body.style.left, 10);
    document.body.style.position = previousBodyPosition.position;
    document.body.style.top = previousBodyPosition.top;
    document.body.style.left = previousBodyPosition.left;
    window.scrollTo(x, y);
    previousBodyPosition = undefined;
  }
};

var isTargetElementTotallyScrolled = function isTargetElementTotallyScrolled(targetElement) {
  return targetElement ? targetElement.scrollHeight - targetElement.scrollTop <= targetElement.clientHeight : false;
};

var handleScroll = function handleScroll(event, targetElement) {
  var clientY = event.targetTouches[0].clientY - initialClientY;
  if (allowTouchMove(event.target)) {
    return false;
  }
  if (targetElement && targetElement.scrollTop === 0 && clientY > 0) {
    return preventDefault(event);
  }
  if (isTargetElementTotallyScrolled(targetElement) && clientY < 0) {
    return preventDefault(event);
  }
  event.stopPropagation();
  return true;
};

var disableBodyScroll$1 = function disableBodyScroll(targetElement, options) {
  if (!targetElement) {
    console.error("disableBodyScroll unsuccessful - targetElement must be provided when calling disableBodyScroll on IOS devices.");
    return;
  }
  if (locks.some((function(lock) {
    return lock.targetElement === targetElement;
  }))) {
    return;
  }
  var lock = {
    targetElement: targetElement,
    options: options || {}
  };
  locks = [].concat(_toConsumableArray(locks), [ lock ]);
  if (isIosDevice) {
    setPositionFixed();
  } else {
    setOverflowHidden(options);
  }
  if (isIosDevice) {
    targetElement.ontouchstart = function(event) {
      if (event.targetTouches.length === 1) {
        initialClientY = event.targetTouches[0].clientY;
      }
    };
    targetElement.ontouchmove = function(event) {
      if (event.targetTouches.length === 1) {
        handleScroll(event, targetElement);
      }
    };
    if (!documentListenerAdded) {
      document.addEventListener("touchmove", preventDefault, hasPassiveEvents ? {
        passive: false
      } : undefined);
      documentListenerAdded = true;
    }
  }
};

var enableBodyScroll$1 = function enableBodyScroll(targetElement) {
  if (!targetElement) {
    console.error("enableBodyScroll unsuccessful - targetElement must be provided when calling enableBodyScroll on IOS devices.");
    return;
  }
  locks = locks.filter((function(lock) {
    return lock.targetElement !== targetElement;
  }));
  if (isIosDevice) {
    targetElement.ontouchstart = null;
    targetElement.ontouchmove = null;
    if (documentListenerAdded && locks.length === 0) {
      document.removeEventListener("touchmove", preventDefault, hasPassiveEvents ? {
        passive: false
      } : undefined);
      documentListenerAdded = false;
    }
  }
  if (isIosDevice) {
    restorePositionSetting();
  } else {
    restoreOverflowSetting();
  }
};

addEventListener("click", (event => {
  window._overlasticTarget = event.target.closest("[data-turbo-frame*=overlay]");
}));

addEventListener("turbo:before-fetch-request", (event => {
  if (!window._overlasticTarget) return;
  const target = window._overlasticTarget;
  const type = target?.dataset?.overlayType;
  const args = target?.dataset?.overlayArgs;
  if (type) {
    event.detail.fetchOptions.headers["Overlay-Type"] = type;
  }
  if (args) {
    event.detail.fetchOptions.headers["Overlay-Args"] = args;
  }
  delete window._overlasticTarget;
}));

class DialogElement extends HTMLElement {
  connectedCallback() {
    disableBodyScroll(this);
    this.addEventListener("click", (event => this.close(event, true)));
    this.querySelector(".overlastic-close").addEventListener("click", (event => this.close(event)));
  }
  close(event, self = false) {
    if (self && event.target !== this) return;
    enableBodyScroll(this);
    setTimeout((() => {
      this.remove();
    }), 5);
  }
}

customElements.define("overlastic-dialog", DialogElement);

class PaneElement extends DialogElement {
  connectedCallback() {
    super.connectedCallback();
    const lastVisit = Turbo.navigator.history.location;
    if (!window.modalVisitStack) {
      window.modalVisitStack = [];
    }
    window.modalVisitStack.push(lastVisit);
    Turbo.navigator.history.push(new URL(this.parentElement.src));
  }
  close(event, self = false) {
    if (self && event.target !== this) return;
    super.close(event, self);
    if (window.modalVisitStack.length > 0) {
      Turbo.navigator.history.replace(window.modalVisitStack.pop());
    }
  }
}

customElements.define("overlastic-pane", PaneElement);

window.disableBodyScroll = disableBodyScroll$1;

window.enableBodyScroll = enableBodyScroll$1;
