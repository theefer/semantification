window.addEventListener('load',  function() {
    function loadArticle(event) {
        event.preventDefault();

        var href = event.target.href;
        var xmlHttpRequest = new XMLHttpRequest();
        xmlHttpRequest.open('GET', href + '.ahah', true);
        xmlHttpRequest.onreadystatechange = function() {
            if (xmlHttpRequest.readyState == 4) {
                var html = xmlHttpRequest.responseText;
                var article = document.getElementById('box');
                article.innerHTML = html;
            }
        };
        xmlHttpRequest.send();
        return false;
    };

    // TODO: apply to all links!
    var el = document.getElementById('test-link');
    el.addEventListener('click', loadArticle);
});
