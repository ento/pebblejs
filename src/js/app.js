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
  subtitle: 'Hello!',
  body: 'Press any button.'
});

main.show();

console.log('Watchface running!');

var app = Elm.worker(Elm.App);

app.ports.tick.subscribe(function(number) {
  console.log('Hello from JavaScript ' + number);
  main.body('Tick ' + number);
});
