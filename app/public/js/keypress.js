
window.onkeypress = function(evt) {

    var key = evt.charCode || evt.keyCode;

    switch (key) {
        case 113:
            document.getElementsByTagName('body')[0].className='fluid-wrap active';
            break;
        case 119:
            document.getElementsByTagName('body')[0].className='fluid-wrap event';
            break;
        case 101:
            document.getElementsByTagName('body')[0].className='fluid-wrap depth';
            break;
    }

}

window.onload = function() {

     document.getElementById('background').addEventListener('click', function() { 
        document.getElementsByTagName('body')[0].className='fluid-wrap depth';
        window.history.pushState({page: 1}, "article", "/events/news-of-the-world-pays-invesigators-to-hack-milly-dowlers-phone/vince-");
     }, true);

}

window.onpopstate = function(state) {
    console.log(event);
}

