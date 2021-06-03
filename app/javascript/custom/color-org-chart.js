const colorOrgChart = () => {
  const circles = document.querySelectorAll('.subcircle');
  if (!circles) {
    return;
  }

  let hue = 0;
  const step = 360 / (circles.length);
  circles.forEach(c => {
    c.style.backgroundColor = `hsl(${hue}, 90%, 88%)`;
    hue += step;
  });
};

export { colorOrgChart };
