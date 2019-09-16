// NOTE: The contents of this file will only be executed if
// you uncomment its entry in "assets/js/app.js".

// To use Phoenix channels, the first step is to import Socket,
// and connect at the socket path in "lib/web/endpoint.ex".
//
// Pass the token on params as below. Or remove it
// from the params if you are not using authentication.
import { Socket } from "phoenix"

// Push the vote up to the server
const pushVote = (el, channel) => {
  channel
    .push('vote', { option_id: el.getAttribute('data-option-id') })
    .receive('ok', res => console.log('You Voted!'))
    .receive('error', res => console.log('Failed to vote:', res));
};

// When we join the channel, do this
const onJoin = (res, channel) => {
  document.querySelectorAll('.vote-button-manual').forEach(el => {
    el.addEventListener('click', event => {
      event.preventDefault();
      pushVote(el, channel);
    });
  });
  console.log('Joined channel:', res);
};

//let socket = new Socket("/socket", {params: {token: window.userToken}})
let socket = new Socket("/socket");

// When you connect, you'll often need to authenticate the client.
// For example, imagine you have an authentication plug, `MyAuth`,
// which authenticates the session and assigns a `:current_user`.
// If the current user exists you can assign the user's token in
// the connection for use in the layout.
//
// In your "lib/web/router.ex":
//
//     pipeline :browser do
//       ...
//       plug MyAuth
//       plug :put_user_token
//     end
//
//     defp put_user_token(conn, _) do
//       if current_user = conn.assigns[:current_user] do
//         token = Phoenix.Token.sign(conn, "user socket", current_user.id)
//         assign(conn, :user_token, token)
//       else
//         conn
//       end
//     end
//
// Now you need to pass this token to JavaScript. You can do so
// inside a script tag in "lib/web/templates/layout/app.html.eex":
//
//     <script>window.userToken = "<%= assigns[:user_token] %>";</script>
//
// You will need to verify the user token in the "connect/3" function
// in "lib/web/channels/user_socket.ex":
//
//     def connect(%{"token" => token}, socket, _connect_info) do
//       # max_age: 1209600 is equivalent to two weeks in seconds
//       case Phoenix.Token.verify(socket, "user socket", token, max_age: 1209600) do
//         {:ok, user_id} ->
//           {:ok, assign(socket, :user, user_id)}
//         {:error, reason} ->
//           :error
//       end
//     end
//
// Finally, connect to the socket:
socket.connect();

// Now that you are connected, you can join channels with a topic:
// Only connect to the socket if the polls channel actually exists!
const enableSocket = document.getElementById('enable-polls-channel');
if (enableSocket) {
    // Pull the Poll Id to find the right topic from the data attribute
  const pollId = enableSocket.getAttribute('data-poll-id');
  // Create a channel to handle joining/sending/receiving
  const channel = socket.channel('polls:' + pollId, {});
  // Next, join the topic on the channel!
  channel
    .join()
    .receive('ok', res => onJoin(res, channel))
    .receive('error', res => console.log('Failed to join channel:', res));

  document.getElementById('polls-ping').addEventListener('click', () => {
    channel
      .push('ping')
      .receive('ok', res => console.log('Received PING response:', res.message))
      .receive('error', res => console.log('Error sending PING:', res));
  });

  channel.on('pong', payload => {
    console.log("The server has been PONG'd and all is well:", payload);
  });

  channel.on('new_vote', ({ option_id, votes }) => {
    document.getElementById('vote-count-' + option_id).innerHTML = votes;
  });
}



export default socket;
