// ES6

/////////////////////////////////////////////////////////////////////////////////
// Destructuring:
/////////////////////////////////////////////////////////////////////////////////

var foo = {
  bar: 1,
  baz: 2
}

var { bar, baz } = foo;
// var bar = foo.bar;
// var baz = foo.baz;



calcBMI( { height: h, weight: w, max = 25, callback } ) {
  // do something
  // h + w, etc
  // callback();
}

calcMBI( { weight, height, callback: function() {} } );


// template strings
var name = 'billiam';
var thing = 'party';
var greet = `Hi, I'm ${name}, and I like to ${thing}!`
var greet2 = `Hello, I'm ${name},
              and I like
              to ${thing}!`


/////////////////////////////////////////////////////////////////////////////////
// block scoping (if statements, loops)
/////////////////////////////////////////////////////////////////////////////////
// let is the new var
// use const mostly, and let to indicate if a value will be mutated
// var is similar to the new global variable
for (20) {
  let b = 2; // it's a new 'b' every time
}
console.log(b); // undefined

if (true) {
  const bar = 2;
}
console.log(bar); // undefined

if (true) {
  var baz = 2;
}
console.log(baz); // 2
var a = 3;
if (true) {
  a += 1;
}
console.log(a); // 4


/////////////////////////////////////////////////////////////////////////////////
// classes
/////////////////////////////////////////////////////////////////////////////////
class Parent {

  // ES7
  age = 34;

  constructor() {

  }

  static foo() {

  }

  bar() {

  }

}

const john = new Parent();
john.bar();
Parent.foo();

// ES7
john.age; // 34

class Child extends Parent {

  constructor() {
    super();
  }

  baz() {

  }

}

const jo = new Child();
jo.baz();
jo.bar();



/////////////////////////////////////////////////////////////////////////////////
// generator functions
/////////////////////////////////////////////////////////////////////////////////

function* myGen() {
  const a = yield $.get('/profile');
  const b = yield $.get('/friends');
  const c = yield $.get('/posts');
}

funcion genWrapper() {
  const gen = myGen(); // initialising the generator
  const yieldVal = gen.next(); // getting the first value
  if ( yieldVal.then ) {
    // if it's thenable (a promise), wait for resolve and pass value back
    yieldVal.then( gen.next );
  }
}


// ES2016 feature
async function() {
  const friends = await $.get('http://somesite.com/friends');
  console.log( friends ); // as if it was sync
}


/////////////////////////////////////////////////////////////////////////////////
// arrow functions
/////////////////////////////////////////////////////////////////////////////////

const adder = ( a, b ) => {
  return a + b;
};

// implicit return (only to one-liners)
doSomething ( (a, b) => a + b );
// implicit return (only to one-arg)
doOtherThing ( c => c + 1 );

[ 0, 1, 2 ].map( val => val++ ); // [ 1, 2, 3 ]

// lexical context binding

// old way
var module = {
  age: 20,
  foo: function() {
    console.log(this.age);
  }
};

var module = {
  age: 20,
  foo: function() {
    setTimeout(function() {
      console.log(this.age);
    }.bind(this), 1000);
  }
};

// new way
var module = {
  age: 20,
  foo: function() {
    setTimeout(() => {
      console.log(this.age);
    }, 1000);
  }
};

// caveat
// (whatever 'this' is out here gets bound to the arrow function this)
$('thing').do().jQuery(() => {
  $(this) // no longer the jQuery this
});

// fix
$('thing').do().jQuery(function() {
  $(this) // back to jQuery this, which is likely window
});


/////////////////////////////////////////////////////////////////////////////////
// module import
/////////////////////////////////////////////////////////////////////////////////

// old way
module.exports.foo = function() {};
module.exports.bar = function() {};
// or
module.exports = function() {};

// import in another file
var myMod = require('myMod');
var foo = myMod.foo;
var bar = myMod.bar;

// new way
export default function() {
  // whole function
};
// or
export default {
  // whole module
}
// or
export function foo() {};
// or
export const pi = 3.14;

// import in another file
import myMod from 'myMod';

// can also destructure
import { each, omit } from 'lodash'; // only pulls in the things you need

// or rename them
import { foo as foolish, pi as mathPi } from 'myMod';


/////////////////////////////////////////////////////////////////////////////////
// comosition
/////////////////////////////////////////////////////////////////////////////////

// reusable functions
const barker = ( state ) => ({ // wrapping the {} so it behaves like an object takig in an arg, not a func
  bark: () => console.log( `Woof, I am ${ state.name }` )
})

const driver = ( state ) => ({
  drive: () => state.position += state.speed
})

// similar to a factory
const killerRobotDog = ( name ) => {
  let state = {
    name,
    speed: 100,
    position: 0
  };
  return Object.assign(
    {},
    barker( state ),
    driver( state ),
    killer( state )
  );
};

barker( { name: 'karo' } ).bark();
killerRobotDog( 'sniffles' ).bark();




//
