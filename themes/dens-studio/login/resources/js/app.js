document.addEventListener("DOMContentLoaded", function () {
  document.querySelectorAll("[data-password-toggle]").forEach(function (toggle) {
    var inputId = toggle.getAttribute("aria-controls");
    var passwordInput = inputId ? document.getElementById(inputId) : null;
    if (!passwordInput) return;

    toggle.addEventListener("click", function () {
      var show = passwordInput.type === "password";
      passwordInput.type = show ? "text" : "password";
      toggle.setAttribute("aria-pressed", String(show));
      toggle.setAttribute("aria-label", show ? "Nascondi password" : "Mostra o nascondi password");
    });
  });
});
