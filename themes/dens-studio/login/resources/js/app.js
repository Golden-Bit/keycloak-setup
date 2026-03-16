document.addEventListener("DOMContentLoaded", function () {
  const toggle = document.querySelector("[data-password-toggle]");
  const passwordInput = document.getElementById("password");
  if (!toggle || !passwordInput) return;
  toggle.addEventListener("click", function () {
    const nextType = passwordInput.type === "password" ? "text" : "password";
    passwordInput.type = nextType;
    toggle.setAttribute("aria-pressed", String(nextType === "text"));
  });
});
