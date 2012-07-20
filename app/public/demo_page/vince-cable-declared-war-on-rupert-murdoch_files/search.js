function setupSearch() {
  var form = document.getElementById('search-form');
  var input = document.getElementById('search-field');
  var results = document.getElementById('search-results');

  function populateResults(data) {
    results.innerHTML = '';
    for (var i = 0; i < data.length; i++) {
      var item = data[i];
      var url = '/' + item.type + 's/' + item.id;
      var html = '<li class="item"><a href="'+url+'">' +item.title+ '</a> <span class="type ' +item.type+ '">' +item.type+ '</span></li>';
      results.innerHTML += html;
    }
  }

  form.onsubmit = function(e) {
    var s = input.value;
    var xmlHttpRequest = new XMLHttpRequest();
    xmlHttpRequest.open('GET', '/api/search/'+s, true);
xmlHttpRequest.setRequestHeader('Accept', 'application/json')
// xmlHttpRequest.setRequestHeader('Accept', 'text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8')
// xmlHttpRequest.setRequestHeader('Cache-Control', 'max-age=0')
// xmlHttpRequest.setRequestHeader('Referer', '')
    xmlHttpRequest.onreadystatechange = function() {
      if (xmlHttpRequest.readyState == 4) {
	var data = JSON.parse(xmlHttpRequest.responseText);
        populateResults(data);
      }
    };
    xmlHttpRequest.send();

    return false;
  };
}

window.addEventListener('load', setupSearch);
