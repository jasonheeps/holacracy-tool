const colorRoleCards = () => {
  const container = document.querySelector('.employee-cards-container');
  if (!container) {
    return;
  }

  const names = container.querySelectorAll('.employee-card');

  names.forEach(n => {
    const hue = Math.random() * 360;
    n.style.color = `hsl(${hue}, 40%, 30%)`;
  });
};

export { colorRoleCards };
