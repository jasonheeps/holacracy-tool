const showHideRoles = () => {
  const btnShow = document.querySelector('.btn-show-roles');
  const btnHide = document.querySelector('.btn-hide-roles');
  if (!btnShow || !btnHide) { return; }

  const buttons = [btnShow, btnHide];
  const roles = document.querySelectorAll('.role');
  buttons.forEach(btn => {
    btn.addEventListener('click', (event) => {
      btnShow.classList.toggle('invisible-content');
      btnHide.classList.toggle('invisible-content');
      roles.forEach(role => {
        role.classList.toggle('invisible-content');
      });
    });
  });

};

export { showHideRoles };
