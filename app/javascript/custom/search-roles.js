const searchRoles = () => {
  const searchbar = document.querySelector('.searchbar-roles');
  if (!searchbar) {
    return;
  }

  searchbar.addEventListener('input', (event) => {
    if (event.target.value === '') {
      searchbar.submit();
    }
  });
};

export { searchRoles };
