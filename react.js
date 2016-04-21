import App from './components/app'
/////////////////////////////////////////////////////////////////////////
// syntax
/////////////////////////////////////////////////////////////////////////

React.render( jsx_or_react_element, target );
// react apps are capitalised (this is the App from line:1 )
React.render( <App />, document.getElementById( 'app' ) );
React.render(
  return (
    // NOTE: JSX takes only one node, but can have nested nodes
    <div>
    <h1> Hello World </h1>
    <div>
    <h2> More Things </h2>
    </div>
    </div>
  ),
  document.getElementById( 'app' )
);

/////////////////////////////////////////////////////////////////////////
// prop(erties)
/////////////////////////////////////////////////////////////////////////
<App first_name="Gator" middle_name="Philip" last_name="Blingin" />
// in the sub-component
export default React.createClass({
  render() {
    let full_name = `${this.props.first_name} ${this.props.last_name}`
    return (
      <div>
        // ES2015 IIFE
        <h1>Hello { full_name }</h1>
      </div>
    )
  }
})

// NOTE: items in a list needs a unique key, React renders by comparing diff
<ul>
  { list.map( ( item, index ) => { return <li key={ index }> { item } </li> } ); }
</ul>

/////////////////////////////////////////////////////////////////////////
// inline CSS
/////////////////////////////////////////////////////////////////////////
// NOTE: class names are defined as:
<div className="myClass"></div>

// inline takes an object rather than string
let styles = {
  color: 'blue',
  height: 100,
  padding: "20px",
  margin: "20px"
}

<div style={ styles }>Introduction to react.js</div>

/////////////////////////////////////////////////////////////////////////
// wrapping child nodes in components
/////////////////////////////////////////////////////////////////////////
// parent
<Modal
  prop1 = { some stuff },
  prop2 = { more stuff },
  prop3 = { handlerFunc }
>
  // this is another module
  // note self-closing
  <Message = { this.props.successMessage } />

</Modal>

// child
export default React.createClass({
  render() {
    return(
      <div className="messageBox">
        <h2> { this.props.prop1 } </h2>
        { this.props.children } // <Message = { /*....*/ } />
        <button onClick={ this.props.accept } />
        <button onClick={ this.props.cancel } />
      </div>
    )
  }
});

/////////////////////////////////////////////////////////////////////////
// event listeners
/////////////////////////////////////////////////////////////////////////
// just use event name as a prop on the element
export default React.createClass({
  handleClick( event ) {
    event.stopPropagation();
    event.preventDefault();
    // NOTE: event is a React syntheticEvent, its values are nullified
    // once this callback is invoked (performance reasons)
    // to pop this event from being event-pooled(reused)
    // do event.persist();
    console.log( event ); // nullified object because of pooling
    // but event properties can be exported
    const { value } = event.target; // same as const value = event.target.value;
  },
  render() {
    // use eventNameCapture to trigger on capture phase
    // eg: onClickCapture
    <button onClick={ this.handleClick }> Click Me </button>
  }
});

/////////////////////////////////////////////////////////////////////////
// component state
/////////////////////////////////////////////////////////////////////////
// initialise: getInitialState( {} );
// setter: this.setState();
export default React.createClass({
  getInitialState() {
    return { inputValue: '', thing2: 'abc' };
  },
  hangleChange( event ) {
    const { value } = event.target;
    this.setState( { thing2: value } );
  },
  render() { /* things */ }
});





















//
