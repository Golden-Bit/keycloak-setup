document.addEventListener("DOMContentLoaded", function () {
  document.querySelectorAll("[data-password-toggle]").forEach(function (toggle) {
    const targetId =
      toggle.getAttribute("data-password-target") ||
      toggle.getAttribute("aria-controls") ||
      "password";
    const input = document.getElementById(targetId);
    if (!input) return;

    toggle.addEventListener("click", function () {
      const nextType = input.type === "password" ? "text" : "password";
      input.type = nextType;
      toggle.setAttribute("aria-pressed", String(nextType === "text"));
    });
  });
});
