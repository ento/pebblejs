/**
 * Welcome to Pebble.js!
 *
 * This is where you write your app.
 */

var UI = require('ui');
var Vector2 = require('vector2');
var Elm = require('elm-module');

var main = new UI.Card({
  title: 'Pebble.elm',
  icon: 'images/menu_icon.png',
  subtitle: 'StartPebble v1',
  body: 'Ticking...'
});

main.show();

console.log('Watchface running!');

var app = Elm.worker(Elm.Watchface);

app.ports.model.subscribe(function(model) {
  console.log('Hello from JavaScript ' + model.time);
  main.body('Tick ' + model.time);
});
