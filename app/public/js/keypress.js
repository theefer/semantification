window.onkeypress = function(evt){
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
