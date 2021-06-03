const sizeOrgChart = () => {
  if (!document.querySelector('.orgchart')) {
    return;
  }

  const GAPS_PERCENTAGE_ROLES = 52;
  const GAPS_PERCENTAGE_CIRCLES = 10;

  const GCC_SIZE_PX = document.querySelector('.circle-0').offsetWidth;
  const ROLES_TOTAL = Array.from(document.querySelectorAll('.role')).length;
  const ROLE_SIZE = GCC_SIZE_PX * Math.sqrt((100 - GAPS_PERCENTAGE_ROLES) / (100.0 * ROLES_TOTAL));
  const ROLE_FONT_SIZE = Math.min(ROLE_SIZE / 9.0, 12)

  const roles = Array.from(document.querySelectorAll('.role'));
  roles.forEach(r => {
    r.style.width = `${ROLE_SIZE}px`;
    r.style.height = `${ROLE_SIZE}px`;
    r.style.fontSize = `${ROLE_FONT_SIZE}px`;
  });

  // TODO: create a real algorithm that calculates optimal sizes for circles
  const subcircles = Array.from(document.querySelectorAll('.subcircle'));
  subcircles.forEach(sc => {
    const roles_count = Array.from(sc.querySelectorAll('.role')).length;
    const subcircles_count = Array.from(sc.querySelectorAll('.subcircle')).length;
    const size = GCC_SIZE_PX * Math.sqrt(parseFloat(roles_count) / ROLES_TOTAL) * ((100 - GAPS_PERCENTAGE_CIRCLES) / 100.0) * (1 + (subcircles_count / 35.0));
    sc.style.width = `${size}px`;
    sc.style.height = `${size}px`;
  });


};

export { sizeOrgChart };
