/**
 * Created by Daniel on 10/11/2017.
 */
App.products = App.cable.subscriptions.create("ProductsChannel", {
  connected: function() {},
  // Called when the subscription is ready for use on the server
  disconnected: function() {},
  // Called when the subscription has been terminated by the server
  received: function(data) {
    // Called when there's incoming data on the websocket for this channel
    return document.getElementsByTagName('main')[0].innerHTML = data.html;
  }
});
