
window.onclick = function(evt) {
  if (evt.target.nodeType == 1 && evt.target.nodeName == 'A') {
    var href = evt.target.href;
    var pathname = evt.target.pathname;
    if (pathname.match(/\/articles\//)) {
      var ahahUri = href + '.ahah';
      reqwest({
        url: ahahUri,
        type: 'html',
        success:function(resp) {
          document.getElementById('main-article').innerHTML = resp;
          document.getElementById('main-article').setAttribute('data-id', pathname);
          window.navigation.setView('depth');

          window.history.pushState({page: 1}, "article", href);
        }
      });

      evt.preventDefault();
    } else if (pathname.match(/\/events\//)) {
      var currentEvent = document.getElementById('main-event'),
          currentEventId = currentEvent.getAttribute('data-id');
      if (currentEventId && pathname == currentEventId) {
        window.navigation.setView('event');
        window.history.pushState({page: 1}, "event", href);
        evt.preventDefault();
      }
      // else fall through, let link load
    }
    // TODO: also for stories
  }
  // TODO: listen to history changes, reflect
}
