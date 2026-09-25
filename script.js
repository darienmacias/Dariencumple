const countdownScreen = document.querySelector("#countdown-screen");
const birthdayContent = document.querySelector("#birthday-content");
const countdown = document.querySelector("#countdown");

function getBirthdayTarget() {
  const now = new Date();
  return new Date(now.getFullYear(), 8, 25, 0, 0, 0, 0);
}

const birthdayTarget = getBirthdayTarget();

function showBirthday() {
  countdownScreen.hidden = true;
  birthdayContent.hidden = false;
}

function renderCountdown() {
  const remaining = birthdayTarget.getTime() - Date.now();

  if (remaining <= 0) {
    showBirthday();
    return;
  }

  const totalSeconds = Math.floor(remaining / 1000);
  const days = Math.floor(totalSeconds / 86400);
  const hours = Math.floor((totalSeconds % 86400) / 3600);
  const minutes = Math.floor((totalSeconds % 3600) / 60);
  const seconds = totalSeconds % 60;

  countdown.innerHTML = [
    ["DÍAS", days],
    ["HORAS", hours],
    ["MINUTOS", minutes],
    ["SEGUNDOS", seconds],
  ]
    .map(
      ([label, value]) => `
        <div class="time-unit">
          <span class="time-number">${String(value).padStart(2, "0")}</span>
          <span class="time-label">${label}</span>
        </div>
      `,
    )
    .join("");
}

if (Date.now() >= birthdayTarget.getTime()) {
  showBirthday();
} else {
  renderCountdown();
}

window.setInterval(renderCountdown, 1000);
