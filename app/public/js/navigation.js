window.navigation = (function() {
  function currentView() {
    return document.body.getAttribute('data-view');
  }

  function setView(name) {
    document.body.setAttribute('data-view', name);
    document.body.className = 'fluid-wrap ' + name;
    document.body.scrollTop = 0;
  }

  return {
    currentView: currentView,
    setView: setView
  };
}());
