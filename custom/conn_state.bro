@load base/protocols/conn

module ConnState;

export {
  global 
}
event connection_established(c: connection) &priority=-5
{
  if (c?$conn_state) {

  }
}
