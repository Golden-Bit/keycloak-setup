document.addEventListener("DOMContentLoaded", function () {
  document.querySelectorAll("[data-password-toggle]").forEach(function (toggle) {
    var targetId = toggle.getAttribute("data-password-target") || toggle.getAttribute("aria-controls");
    var passwordInput = targetId ? document.getElementById(targetId) : null;
    if (!passwordInput) return;

    toggle.addEventListener("click", function () {
      var nextType = passwordInput.type === "password" ? "text" : "password";
      passwordInput.type = nextType;
      toggle.setAttribute("aria-pressed", String(nextType === "text"));
    });
  });
});
