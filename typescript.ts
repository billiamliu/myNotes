/////////////////////////////////////////////////////////////////////////
// types
/////////////////////////////////////////////////////////////////////////

// this function expects a string as the argument
function greeter( person: string ) {
  return `Hello ${ person }!`;
}

// boolean
// number
// string
// array
// tuple ( array with a fixed number of known types )
  // let x: [ string, number ];
  // x = [ 'hello', 13 ]; // ok
  // x = [ 12, 'hi' ]; // not ok
  // x[ 2 ] = 'world'; // ok ( it's either a number or string )
  // x[ 3 ] = true; // error, boo is neither num nor str
// enum ( good for getting keys or values )
  // can set default index, too
  enum Colour { Red = 1, Green, Blue = 4, Purple };
  let idx: Colour = Colour.Purple; // 5
  let value: String = Colour[ 2 ]; // 'Green'
// any ( can be semi-flexible: any[] )
// void ( for funcs that don't return, or assign to null/undefined vars )
  function popUp(): void {
    alert( 'hello' );
  }
// type assersion / casting
  let someVal: any = 'stringsssss';
  let strLength: number = ( someVal as string ).length;

/////////////////////////////////////////////////////////////////////////
// interfaces
/////////////////////////////////////////////////////////////////////////

// two types are compatible if their internal structure is compatible
interface Person {
  firstName: string;
  lastName: string;
}

// this is compatible with the Perso interface
let user = {
  firstName: 'Jane',
  lastName: 'Doe'
}
