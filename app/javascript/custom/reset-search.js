const resetSearch = () => {
  const searchbar = document.querySelector('.searchbar-roles, .searchbar-employees');
  if (!searchbar) {
    return;
  }

  searchbar.addEventListener('input', (event) => {
    if (event.target.value === '') {
      searchbar.submit();
    }
  });
};

export { resetSearch };
