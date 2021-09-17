const togglePassword = () => {
  // NOTE: it's essential to declare the const inside(!) the function
  // otherwise the code won't apply on heroku
  const passwordInput = document.querySelector('#password');
  const toggler = document.querySelector('#toggle-password');
  if (passwordInput && toggler) {
    const show = document.querySelector('#show-password');
    const hide = document.querySelector('#hide-password');

    toggler.addEventListener('click', (event) => {
      if (passwordInput.type === "password") {
        passwordInput.type = "text";
        show.style.display = "none";
        hide.style.display = "inline";
      }
      else 
      {
        passwordInput.type = "password";
        show.style.display = "inline";
        hide.style.display = "none";
      }
    });
  }
};

export { togglePassword };

