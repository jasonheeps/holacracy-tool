const highlightNavbarTabs = () => {
  const navbar = document.querySelector('.navbar');
  if (!navbar) {
    return;
  }

  const tabs = document.querySelectorAll('.navbar-link');
  tabs.forEach(t => {
    t.addEventListener('click', (event) => {
      // const active_before = document.querySelector('.active')
      // if (active_before) {
      //   active_before.classList.remove('active');
      // }
      // console.log(event.target);
      // event.target.classList.add('navbar-link-active');
    });
  });

};

export { highlightNavbarTabs };
