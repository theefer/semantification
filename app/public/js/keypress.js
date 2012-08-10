window.onkeydown = function(evt) {
    var key = evt.charCode || evt.keyCode;
    var LEFT  = 37,
        UP    = 38,
        RIGHT = 39,
        DOWN  = 40;
    var offset;
    switch(key) {
    case LEFT:  offset = -1; break;
    case RIGHT: offset = 1;  break;
    default:    return;
    }

    var body = document.getElementsByTagName('body')[0];

    var viewOrder = ['background', 'event', 'depth'];
    var currentView = window.navigation.currentView();
    var maxOffset = viewOrder.length - 1;
    var currentOrderOffset = viewOrder.indexOf(currentView);
    var nextOrderOffset = Math.max(0, Math.min(maxOffset, currentOrderOffset + offset));

    window.navigation.setView(viewOrder[nextOrderOffset]);
    // TODO: update URL/window.history
}

// window.onpopstate = function(event) {
//   console.log(event);
// }
