document.addEventListener("DOMContentLoaded", function () {
  initPasswordToggles(document);
  enhanceRegistrationForm();
});

function initPasswordToggles(root) {
  (root || document).querySelectorAll("[data-password-toggle]").forEach(function (toggle) {
    if (toggle.dataset.densToggleBound === "true") return;

    var targetId = toggle.getAttribute("data-password-target") || toggle.getAttribute("aria-controls");
    var passwordInput = targetId ? document.getElementById(targetId) : null;
    if (!passwordInput) return;

    toggle.dataset.densToggleBound = "true";
    toggle.addEventListener("click", function () {
      var nextType = passwordInput.type === "password" ? "text" : "password";
      passwordInput.type = nextType;
      toggle.setAttribute("aria-pressed", String(nextType === "text"));
    });
  });
}

function enhanceRegistrationForm() {
  var form = document.getElementById("kc-register-form");
  if (!form) return;

  form.querySelectorAll(".dens-kc-field").forEach(function (field) {
    if (field.querySelector(".g-recaptcha")) return;

    var control = field.querySelector(
      'input:not([type="hidden"]):not([type="checkbox"]):not([type="radio"]), select, textarea'
    );

    if (!control) return;

    normalizeControl(control);

    var existingWrap = control.closest(".dens-input-wrap");
    if (existingWrap) {
      existingWrap.classList.add("dens-input-wrap--enhanced");
      movePasswordToggleInside(field, existingWrap);
      cleanupEmptyWrappers(field, existingWrap);
      return;
    }

    var wrap = document.createElement("div");
    wrap.className = "dens-input-wrap dens-input-wrap--enhanced";

    var label = field.querySelector("label");
    var anchor = label || field.firstElementChild;

    if (anchor && anchor.nextSibling) {
      anchor.parentNode.insertBefore(wrap, anchor.nextSibling);
    } else {
      field.appendChild(wrap);
    }

    wrap.appendChild(control);
    movePasswordToggleInside(field, wrap);
    cleanupEmptyWrappers(field, wrap);
  });

  initPasswordToggles(form);
}

function normalizeControl(control) {
  control.classList.add("dens-plain-input");

  if (control.tagName === "TEXTAREA") {
    control.classList.add("dens-plain-input--textarea");
  }

  if (control.tagName === "SELECT") {
    control.classList.add("dens-plain-input--select");
  }

  if (control.type === "password") {
    control.classList.add("dens-input--password");
  }

  control.removeAttribute("size");
  control.removeAttribute("style");
  control.style.width = "100%";
}

function movePasswordToggleInside(field, wrap) {
  var toggle = field.querySelector("[data-password-toggle]");
  if (!toggle || wrap.contains(toggle)) return;
  wrap.appendChild(toggle);
}

function cleanupEmptyWrappers(field, activeWrap) {
  field.querySelectorAll("div, span").forEach(function (node) {
    if (node === field || node === activeWrap) return;
    if (node.classList.contains("dens-input-wrap")) return;
    if (node.querySelector(".dens-input-wrap")) return;
    if (node.querySelector("input, select, textarea, button")) return;
    if (node.textContent.trim() !== "") return;
    node.remove();
  });
}
